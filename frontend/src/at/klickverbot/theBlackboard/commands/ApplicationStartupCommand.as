import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.SequenceCommand;
import at.klickverbot.theBlackboard.commands.GetConfigCommand;
import at.klickverbot.theBlackboard.commands.GetConfigLocationCommand;
import at.klickverbot.theBlackboard.commands.ViewEntriesCommand;

class at.klickverbot.theBlackboard.commands.ApplicationStartupCommand
   extends SequenceCommand implements ICommand {

   private function initSequence() :Void {
      addCommand( GetConfigLocationCommand );
      addCommand( GetConfigCommand );
      addCommand( ViewEntriesCommand );
   }
}
