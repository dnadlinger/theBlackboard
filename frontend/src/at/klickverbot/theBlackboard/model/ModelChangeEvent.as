import at.klickverbot.event.events.PropertyChangeEvent;

class at.klickverbot.theBlackboard.model.ModelChangeEvent extends PropertyChangeEvent {
   public static var CONFIG :String = "configurationChange";
   public static var SERVICE_ERRORS :String = "serviceErrorsChange";
   public static var ENTRY_COUNT :String = "entryCountChange";
   public static var CURRENT_ENTRIES :String = "currentEntriesChange";
   public static var ENTRY_UPDATING_ACTIVE :String = "entryUpdatingActiveChange";
   public static var APPLICATION_STATE :String = "applicationStateChange";
   public static var NEW_ENTRY :String = "newEntry";
   public static var SELECTED_ENTRY :String = "selectedEntry";

   public function ModelChangeEvent( type :String, target :Object,
      oldValue :Object, newValue :Object ) {
      super( type, target, oldValue, newValue );
   }
}
