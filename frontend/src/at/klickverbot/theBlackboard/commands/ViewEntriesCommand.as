import at.klickverbot.cairngorm.commands.AbstractCommand;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.GetEntriesEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.vo.ApplicationState;
import at.klickverbot.theBlackboard.vo.EntrySet;

class at.klickverbot.theBlackboard.commands.ViewEntriesCommand
   extends AbstractCommand implements ICommand {

   public function execute( event :CairngormEvent ) :Void {
      // Refresh the view.
      var currentSet :EntrySet = Model.getInstance().currentEntries;
      if ( currentSet != null ) {
         ( new GetEntriesEvent(
            currentSet.sortingType,
            currentSet.startOffset,
            currentSet.entryLimit,
            true
         ) ).dispatch();
      }

      Model.getInstance().applicationState = ApplicationState.VIEW_ENTRIES;
      complete();
   }
}
