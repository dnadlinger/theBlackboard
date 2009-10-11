import at.klickverbot.theBlackboard.control.Controller;
import at.klickverbot.cairngorm.control.CairngormEvent;

class at.klickverbot.theBlackboard.control.AddEntryEvent extends CairngormEvent {
   public function AddEntryEvent() {
      super( Controller.ADD_ENTRY );
   }
}
