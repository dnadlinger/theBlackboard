import at.klickverbot.event.events.PropertyChangeEvent;

class at.klickverbot.theBlackboard.model.ApplicationModelChangeEvent extends PropertyChangeEvent {
	public static var CONFIGURATION :String = "changeConfiguration";
	public static var ENTRIES :String = "changeEntries";
   public static var SERVICE_ERRORS :String = "chanceServiceErrors";

   public function ApplicationModelChangeEvent( type :String, target :Object,
      oldValue :Object, newValue :Object ) {
      super( type, target, oldValue, newValue );
   }
}
