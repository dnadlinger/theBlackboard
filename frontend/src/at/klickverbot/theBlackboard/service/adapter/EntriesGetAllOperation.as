import at.klickverbot.debug.Logger;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.model.EntriesSortingType;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.backend.IEntriesBackend;

class at.klickverbot.theBlackboard.service.adapter.EntriesGetAllOperation extends AdapterOperation {
   public function EntriesGetAllOperation( backend :IEntriesBackend,
      sortingType :EntriesSortingType ) {
      super( backend.getAllIds( getSortingString( sortingType ) ) );
   }

   private function handleResult( event :ResultEvent ) :Void {
      var result :Array = new Array();

      var ids :Array = Array( event.result );
      for ( var i :Number = 0; i < ids.length; ++i ) {
         var entry :Entry = new Entry();
         entry.id = ids[ i ];
         result.push( entry );
      }

      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, result ) );
   }

   private function getSortingString( type :EntriesSortingType ) :String {
      // Now we can get the ids for the entries we want to load.
      if ( type == EntriesSortingType.OLD_TO_NEW ) {
         return "oldToNew";
      } else if ( type == EntriesSortingType.NEW_TO_OLD ) {
         return "newToOld";
      } else {
         Logger.getLog( "GetAllEntriesOperation" ).warn(
            "Unknown sorting type: " + type );
         return "";
      }
   }
}
