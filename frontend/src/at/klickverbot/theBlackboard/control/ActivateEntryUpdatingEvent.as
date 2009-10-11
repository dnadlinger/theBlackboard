import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.Controller;

class at.klickverbot.theBlackboard.control.ActivateEntryUpdatingEvent extends CairngormEvent {
   public function ActivateEntryUpdatingEvent() {
      super( Controller.ACTIVATE_ENTRY_UPDATING );
   }
}
