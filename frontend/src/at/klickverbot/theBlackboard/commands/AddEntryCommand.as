import at.klickverbot.cairngorm.commands.AbstractCommand;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.SuspendEntryUpdatingEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.vo.ApplicationState;
import at.klickverbot.theBlackboard.vo.Entry;

class at.klickverbot.theBlackboard.commands.AddEntryCommand
   extends AbstractCommand implements ICommand {

   public function execute( event :CairngormEvent ) :Void {
      // TODO: Is dispatching an event in a command a good idea?
      var updatingEvent :SuspendEntryUpdatingEvent = new SuspendEntryUpdatingEvent();
      updatingEvent.dispatch();

      var entry :Entry = new Entry();
      entry.caption = "";
      entry.author = "";

      Model.getInstance().newEntry = entry;
      Model.getInstance().selectedEntry = entry;
      Model.getInstance().applicationState = ApplicationState.DRAW_ENTRY;
   }
}
