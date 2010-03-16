import at.klickverbot.debug.Logger;
import at.klickverbot.drawing.DrawingStringifier;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.adapter.EntryParser;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceLocator;
import at.klickverbot.theBlackboard.model.EntriesSortingType;
import at.klickverbot.theBlackboard.model.Entry;

class at.klickverbot.theBlackboard.service.adapter.EntryDelegate extends EventDispatcher {
   public static function setServiceLocation( location :ServiceLocation ) :Boolean {
      return ServiceLocator.getInstance().initEntriesService( location );
   }

   public function getEntryCount() :Void {
      var countOperation :IOperation =
         ServiceLocator.getInstance().entriesService.getEntryCount();

      // The result is already in the correct format (it is just a plain number),
      // so we just pass it to the responder.
      countOperation.addEventListener( ResultEvent.RESULT, this, dispatchEvent );
      countOperation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
      countOperation.execute();
   }

   public function getAllEntries( sortingType :EntriesSortingType ) :Void {
      var idsOperation :IOperation =
         ServiceLocator.getInstance().entriesService.getAllIds(
            getSortingString( sortingType ) );

      idsOperation.addEventListener( ResultEvent.RESULT, this, handleAllIdsResult );
      idsOperation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
      idsOperation.execute();
   }

   public function addEntry( entry :Entry ) :Void {
      var stringifier :DrawingStringifier = new DrawingStringifier();
      var drawingString :String = stringifier.makeString( entry.drawing );

      var addOperation :IOperation =
         ServiceLocator.getInstance().entriesService.addEntry(
            entry.caption, entry.author, drawingString );

      // addEntry returns nothing if everything went correctly.
      addOperation.addEventListener( ResultEvent.RESULT, this, dispatchEvent );
      addOperation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
      addOperation.execute();
   }

   public function getEntryById( id :Number ) :Void {
      var entryOperation :IOperation =
         ServiceLocator.getInstance().entriesService.getEntryById( id );

      entryOperation.addEventListener( ResultEvent.RESULT, this, handleEntryResult );
      entryOperation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
      entryOperation.execute();
   }

   private function handleAllIdsResult( event :ResultEvent ) :Void {
      var result :Array = new Array();

      var ids :Array = Array( event.result );
      for ( var i :Number = 0; i < ids.length; ++i ) {
         var entry :Entry = new Entry();
         entry.id = ids[ i ];
         result.push( entry );
      }

      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, result ) );
   }

   private function handleEntryResult( event :ResultEvent ) :Void {
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this,
         ( new EntryParser() ).parseEntry( event.result ) ) );
   }

   private function getSortingString( type :EntriesSortingType ) :String {
      // Now we can get the ids for the entries we want to load.
      if ( type == EntriesSortingType.OLD_TO_NEW ) {
         return "oldToNew";
      } else if ( type == EntriesSortingType.NEW_TO_OLD ) {
         return "newToOld";
      } else {
         Logger.getLog( "EntryDelegate" ).warn( "Unknown sorting type: " + type );
         return "";
      }
   }
}
