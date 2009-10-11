import at.klickverbot.cairngorm.control.FrontController;
import at.klickverbot.theBlackboard.commands.ActivateEntryUpdatingCommand;
import at.klickverbot.theBlackboard.commands.AddEntryCommand;
import at.klickverbot.theBlackboard.commands.ApplicationStartupCommand;
import at.klickverbot.theBlackboard.commands.EditEntryDetailsCommand;
import at.klickverbot.theBlackboard.commands.GetEntriesCommand;
import at.klickverbot.theBlackboard.commands.SaveEntryCommand;
import at.klickverbot.theBlackboard.commands.SuspendEntryUpdatingCommand;

class at.klickverbot.theBlackboard.control.Controller
   extends FrontController {

   public function init() :Void {
      addCommand( APPLICATION_STARTUP, ApplicationStartupCommand );
      addCommand( GET_ENTRIES, GetEntriesCommand );
      addCommand( ACTIVATE_ENTRY_UPDATING, ActivateEntryUpdatingCommand );
      addCommand( SUSPEND_ENTRY_UPDATING, SuspendEntryUpdatingCommand );
      addCommand( ADD_ENTRY, AddEntryCommand );
      addCommand( EDIT_ENTRY_DETAILS, EditEntryDetailsCommand );
      addCommand( SAVE_ENTRY, SaveEntryCommand );
   }

   public static var APPLICATION_STARTUP :String = "applicationStartup";

   public static var ACTIVATE_ENTRY_UPDATING :String = "activateEntryUpdating";
   public static var SUSPEND_ENTRY_UPDATING :String = "suspendEntryUpdating";

   public static var GET_ENTRIES :String = "getEntries";

   public static var ADD_ENTRY :String = "addEntry";
   public static var EDIT_ENTRY_DETAILS :String = "editEntryDetails";
   public static var SAVE_ENTRY :String = "pushEntry";
}
