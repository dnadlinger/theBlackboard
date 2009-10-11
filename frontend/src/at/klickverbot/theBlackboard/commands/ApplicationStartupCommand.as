import at.klickverbot.theBlackboard.commands.ViewEntriesCommand;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.SequenceCommand;
import at.klickverbot.theBlackboard.commands.GetConfigCommand;
import at.klickverbot.theBlackboard.commands.GetConfigLocationCommand;

class at.klickverbot.theBlackboard.commands.ApplicationStartupCommand
   extends SequenceCommand implements ICommand {

   private function initSequence() :Void {
      addCommand( GetConfigLocationCommand );
      addCommand( GetConfigCommand );
      addCommand( ViewEntriesCommand );
   }
}
