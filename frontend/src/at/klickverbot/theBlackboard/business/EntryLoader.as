import at.klickverbot.core.CoreObject;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.business.EntryParser;
import at.klickverbot.theBlackboard.business.EntrySetRequest;
import at.klickverbot.theBlackboard.business.ServiceLocator;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.vo.EntriesSortingType;
import at.klickverbot.theBlackboard.vo.Entry;
import at.klickverbot.theBlackboard.vo.EntrySet;

/**
 * Singleton for loading and caching entries.
 *
 */
class at.klickverbot.theBlackboard.business.EntryLoader extends CoreObject {
   private function EntryLoader() {
      m_entryCache = new Array();
      m_resultSet = null;
      m_currentEntryIds = null;
      m_entryOperation = null;
      m_currentEntryIndex = 0;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of EntryLoader.
    */
   public static function getInstance() :EntryLoader {
      if ( m_instance == null ) {
         m_instance = new EntryLoader();
      }
      return m_instance;
   }

   public function processRequest( request :EntrySetRequest ) :Void {
      // TODO: Stop any currently running request.
      // TODO: Query for last change?
      // TODO: Cache the ids for a certain amount of time?
      // TODO: Cache the ids as long as the total count has not been changed?
      m_currentRequest = request;

      // First, we ask the backend how many entries it has in total.
      var countOperation :IOperation =
         ServiceLocator.getInstance().entriesService.getEntryCount();
      countOperation.addEventListener( ResultEvent.RESULT, this, handleCountResult );
      countOperation.addEventListener( FaultEvent.FAULT, this, failCurrentTask );
      countOperation.execute();
   }

   private function handleCountResult( event :ResultEvent ) :Void {
      // The service result contains the total entry count; we have to substract
      // the requested offset to get the number of entries which are actually
      // available.
      var availableEntryCount :Number = Math.max( 0, ( Number( event.result ) -
         m_currentRequest.startOffset ) );

      // The result set cannot contain more entries than available.
      var resultEntryCount :Number = Math.min( m_currentRequest.entryLimit, availableEntryCount );

      // Regardless of the preload limit, we want to load at least the number
      // of entries requested. We cannot load more entries than available though.
      var loadLimit :Number = Math.max( m_currentRequest.entryLimit,
         Model.getInstance().config.entryPreloadLimit );
      var numEntriesToLoad :Number = Math.min( loadLimit, availableEntryCount );

      // Construct the result set (all entries empty by now) and yield it to
      // the responder of the task.
      m_resultSet = new EntrySet( m_currentRequest.sortingType,
         m_currentRequest.startOffset, resultEntryCount, availableEntryCount,
         m_currentRequest.entryLimit );
      m_currentRequest.responder.onResult( new ResultEvent( ResultEvent.RESULT,
         this, m_resultSet ) );

      // Return now if we don't have any entries to load.
      if ( numEntriesToLoad == 0 ) {
         return;
      }

      // Now we can get the ids for the entries we want to load.
      var sortingString :String;
      if ( m_currentRequest.sortingType == EntriesSortingType.OLD_TO_NEW ) {
         sortingString = "oldToNew";
      } else if ( m_currentRequest.sortingType == EntriesSortingType.NEW_TO_OLD ) {
         sortingString = "newToOld";
      } else {
         failCurrentTaskWithMessage( "Unknown sorting type." );
         return;
      }

      var idOperation :IOperation =
         ServiceLocator.getInstance().entriesService.getIdsForRange(
         sortingString, m_currentRequest.startOffset, numEntriesToLoad );

      idOperation.addEventListener( ResultEvent.RESULT, this, handleIdResult );
      idOperation.addEventListener( FaultEvent.FAULT, this, failCurrentTask );
      idOperation.execute();
   }

   private function handleIdResult( event :ResultEvent ) :Void {
      m_currentEntryIds = Array( event.result );

      // There should be at least as many ids as we
      if ( m_currentEntryIds.length < m_resultSet.entryCount ) {
         failCurrentTaskWithMessage(
            "The id set recieved from the server is shorter than expected!" );
         return;
      }

      // If there is any entry loading operation currently running, remove the
      // listeners from it, so its results are not written into the new EntrySet
      // and it does not disturb our loading chain.
      if ( m_entryOperation != null ) {
         m_entryOperation.removeEventListener( ResultEvent.RESULT, this, handleEntryResult );
         m_entryOperation.removeEventListener( FaultEvent.FAULT, this, failCurrentTask );
      }

      // Start the loading chain.
      m_currentEntryIndex = 0;
      loadEntry();
   }

   private function loadEntry() :Void {
      // TODO: Maybe add an option to "flush" the cache here?
      var entryId :Number = m_currentEntryIds[ m_currentEntryIndex ];

      // Is the current entry already in the cache?
      if ( m_entryCache[ entryId ] == null ) {
         // No, we have to get it from the backend.
         m_entryOperation = ServiceLocator.getInstance().entriesService.getEntryById( entryId );
         m_entryOperation.addEventListener( ResultEvent.RESULT, this, handleEntryResult );
         m_entryOperation.addEventListener( FaultEvent.FAULT, this, failCurrentTask );
         m_entryOperation.execute();
      } else {
         // Update the corresponding entry in the result set if it was not just
         // preloaded.
         if ( m_currentEntryIndex < m_resultSet.entryCount ) {
            m_resultSet.getEntryAt( m_currentEntryIndex ).copyFrom( m_entryCache[ entryId ] );
         }

         // Proceed with the next entry if we are not done yet.
         if ( m_currentEntryIndex < ( m_currentEntryIds.length - 1 ) ) {
            ++m_currentEntryIndex;
            loadEntry();
         }
      }
   }

   private function handleEntryResult( event :ResultEvent ) :Void {
      // We don't need the current entry loading operation any longer.
      m_entryOperation.removeEventListener( ResultEvent.RESULT, this, handleEntryResult );
      m_entryOperation.removeEventListener( FaultEvent.FAULT, this, failCurrentTask );
      m_entryOperation = null;

      // Parse the raw data into an Entry and store it in the cache.
      var entryParser :EntryParser = new EntryParser();
      var newEntry :Entry = entryParser.parseEntry( event.result );
      if ( newEntry == null ) {
         failCurrentTaskWithMessage( "Entry " +
            m_currentEntryIds[ m_currentEntryIndex ] + " incomplete." );
         return;
      }
      m_entryCache[ m_currentEntryIds[ m_currentEntryIndex ] ] = newEntry;

      // Jump back into loading chain. It will detect that the current entry
      // is already in the cache and proceed with the next entry – if any.
      loadEntry();
   }

   private function failCurrentTask( faultEvent :FaultEvent ) :Void {
      m_currentRequest.responder.onFault( faultEvent );
      m_currentRequest = null;
   }

   private function failCurrentTaskWithMessage( message :String ) :Void {
      failCurrentTask( new FaultEvent( FaultEvent.FAULT, this,	null, message ) );
   }

   private static var m_instance :EntryLoader;

   private var m_entryCache :Array;

   private var m_currentRequest :EntrySetRequest;

   private var m_resultSet :EntrySet;
   private var m_currentEntryIds :Array;

   private var m_entryOperation :IOperation;
   private var m_currentEntryIndex :Number;
}
