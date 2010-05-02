import at.klickverbot.drawing.DrawingStringifier;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.backend.IEntriesBackend;

class at.klickverbot.theBlackboard.service.adapter.EntriesAddOperation extends AdapterOperation {
   public function EntriesAddOperation( backend :IEntriesBackend, entry :Entry,
      filters :Array ) {

      m_target = entry;

      var stringifier :DrawingStringifier = new DrawingStringifier();
      var drawingString :String = stringifier.makeString( entry.drawing );

      super( backend.addEntry( entry.caption, entry.author, drawingString ), filters );
   }

   private function handleResult( event :ResultEvent ) :Void {
      m_target.dirty = false;
      super.handleResult( event );
   }

   private var m_target :Entry;
}
