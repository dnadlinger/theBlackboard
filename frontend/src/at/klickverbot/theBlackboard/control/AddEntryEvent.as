import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.Controller;

class at.klickverbot.theBlackboard.control.AddEntryEvent extends CairngormEvent {
   public function AddEntryEvent() {
      super( Controller.ADD_ENTRY );
   }
}
