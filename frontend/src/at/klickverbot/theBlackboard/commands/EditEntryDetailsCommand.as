import at.klickverbot.cairngorm.commands.AbstractCommand;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.SuspendEntryUpdatingEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.vo.ApplicationState;

class at.klickverbot.theBlackboard.commands.EditEntryDetailsCommand
   extends AbstractCommand implements ICommand {

   public function execute( event :CairngormEvent ) :Void {
      // TODO: Is dispatching an event in a command a good idea?
      var updatingEvent :SuspendEntryUpdatingEvent = new SuspendEntryUpdatingEvent();
      updatingEvent.dispatch();

      Model.getInstance().applicationState = ApplicationState.EDIT_ENTRY_DETAILS;
   }
}
