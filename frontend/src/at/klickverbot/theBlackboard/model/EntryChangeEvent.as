import at.klickverbot.event.events.PropertyChangeEvent;

class at.klickverbot.theBlackboard.model.EntryChangeEvent extends PropertyChangeEvent {
   public static var ID :String = "changeId";
   public static var CAPTION :String = "changeCaption";
   public static var AUTHOR :String = "changeAuthor";
   public static var DRAWING :String = "changeDrawing";
   public static var TIMESTAMP :String = "changeTimestamp";
   public static var LOADED :String = "changeLoaded";

   public function EntryChangeEvent( type :String, target :Object,
      oldValue :Object, newValue :Object ) {
      super( type, target, oldValue, newValue );
   }
}
