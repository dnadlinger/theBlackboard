import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.SequenceCommand;
import at.klickverbot.theBlackboard.commands.PushEntryCommand;
import at.klickverbot.theBlackboard.commands.ViewEntriesCommand;

class at.klickverbot.theBlackboard.commands.SaveEntryCommand
   extends SequenceCommand implements ICommand {

   private function initSequence() :Void {
      addCommand( PushEntryCommand );
      addCommand( ViewEntriesCommand );
   }
}
