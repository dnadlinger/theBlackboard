import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.Controller;

class at.klickverbot.theBlackboard.control.EditEntryDetailsEvent extends CairngormEvent {
   public function EditEntryDetailsEvent() {
      super( Controller.EDIT_ENTRY_DETAILS );
   }
}
