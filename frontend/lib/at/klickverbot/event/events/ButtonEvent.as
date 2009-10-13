import at.klickverbot.event.events.UiEvent;

class at.klickverbot.event.events.ButtonEvent extends UiEvent {
   public static var PRESS :String = "buttonPress";
   public static var RELEASE :String = "buttonRelease";
   public static var RELEASE_OUTSIDE :String = "buttonReleaseOutside";

   public function ButtonEvent( type :String, target :Object ) {
      super( type, target );
   }
}
