import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.Controller;

class at.klickverbot.theBlackboard.control.SuspendEntryUpdatingEvent extends CairngormEvent {
   public function SuspendEntryUpdatingEvent() {
      super( Controller.SUSPEND_ENTRY_UPDATING );
   }
}
