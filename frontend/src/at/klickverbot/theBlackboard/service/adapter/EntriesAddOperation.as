import at.klickverbot.drawing.DrawingStringifier;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.backend.IEntriesBackend;

class at.klickverbot.theBlackboard.service.adapter.EntriesAddOperation extends AdapterOperation {
   public function EntriesAddOperation( backend :IEntriesBackend, entry :Entry ) {
      var stringifier :DrawingStringifier = new DrawingStringifier();
      var drawingString :String = stringifier.makeString( entry.drawing );

      super( backend.addEntry( entry.caption, entry.author, drawingString ) );
   }
}
