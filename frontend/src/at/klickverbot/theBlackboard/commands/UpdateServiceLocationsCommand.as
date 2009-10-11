import at.klickverbot.cairngorm.commands.AbstractCommand;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.business.EntryDelegate;
import at.klickverbot.theBlackboard.model.Model;

class at.klickverbot.theBlackboard.commands.UpdateServiceLocationsCommand
   extends AbstractCommand implements ICommand {

   public function execute( event :CairngormEvent ) :Void {
      EntryDelegate.setEntriesService( Model.getInstance().config.entryServiceLocation );
      complete();
   }
}
