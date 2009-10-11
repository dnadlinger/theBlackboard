import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.SequenceCommand;
import at.klickverbot.theBlackboard.commands.LoadConfigCommand;
import at.klickverbot.theBlackboard.commands.UpdateServiceLocationsCommand;

class at.klickverbot.theBlackboard.commands.GetConfigCommand
   extends SequenceCommand implements ICommand {

   private function initSequence() :Void {
      addCommand( LoadConfigCommand );
      addCommand( UpdateServiceLocationsCommand );
   }
}