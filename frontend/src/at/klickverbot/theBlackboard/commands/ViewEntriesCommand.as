import at.klickverbot.theBlackboard.vo.EntriesSortingType;
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
      var currentSet :EntrySet = Model.getInstance().currentEntries;
      if ( currentSet == null ) {
         // If no entries are present yet, load the DEFAULT_ENTRY_COUNT last
         // entries.
         ( new GetEntriesEvent(
            DEFAULT_SORTING_TYPE,
            Model.getInstance().entryCount - DEFAULT_ENTRY_COUNT,
            DEFAULT_ENTRY_COUNT,
            false
         ) ).dispatch();
      } else {
         // Refresh the view.
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

   /**
    * The sorting type for the first entry set loaded.
    */
   private static var DEFAULT_SORTING_TYPE :EntriesSortingType =
      EntriesSortingType.OLD_TO_NEW;

   /**
    * The number of entries loaded for the first entry set.
    *
    * Later, the views will request a certain number of entries to be loaded
    * based on their capacity.
    */
   private static var DEFAULT_ENTRY_COUNT :Number = 1;
}
