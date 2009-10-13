import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.core.CoreObject;
import at.klickverbot.drawing.DrawingStringifier;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.business.EntryLoader;
import at.klickverbot.theBlackboard.business.EntrySetRequest;
import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.business.ServiceLocator;
import at.klickverbot.theBlackboard.vo.EntriesSortingType;
import at.klickverbot.theBlackboard.vo.Entry;

class at.klickverbot.theBlackboard.business.EntryDelegate extends CoreObject
   implements IResponder {

   /**
    * Constructor.
    */
   public function EntryDelegate( responder :IResponder ) {
      m_responder = responder;
   }

   public static function setEntriesService( location :ServiceLocation ) :Boolean {
      return ServiceLocator.getInstance().initEntriesService( location );
   }

   public function getEntryCount() :Void {
      var countOperation :IOperation =
         ServiceLocator.getInstance().entriesService.getEntryCount();

      // The result is already in the correct format (it is just a plain number),
      // so we just pass it to the responder.
      countOperation.addEventListener( ResultEvent.RESULT, this, onResult );
      countOperation.addEventListener( FaultEvent.FAULT, this, onFault );
      countOperation.execute();
   }

   public function getEntryRange( sortingType :EntriesSortingType,
      startOffset :Number, entryLimit :Number ) :Void {
      EntryLoader.getInstance().processRequest( new EntrySetRequest(
         this, sortingType, startOffset, entryLimit ) );
   }

   public function addEntry( entry :Entry ) :Void {
      var stringifier :DrawingStringifier = new DrawingStringifier();
      var drawingString :String = stringifier.makeString( entry.drawing );

      var addOperation :IOperation =
         ServiceLocator.getInstance().entriesService.addEntry(
            entry.caption, entry.author, drawingString );

      // addEntry returns nothing if everything went correctly.
      addOperation.addEventListener( ResultEvent.RESULT, this, onResult );
      addOperation.addEventListener( FaultEvent.FAULT, this, onFault );
      addOperation.execute();
   }

   public function onResult( data :ResultEvent ) :Void {
      m_responder.onResult( data );
   }

   public function onFault( info :FaultEvent ) :Void {
      m_responder.onFault( info );
   }

   private var m_responder :IResponder;
}