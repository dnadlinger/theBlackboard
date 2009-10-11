import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.ButtonEvent extends Event {
   public static var PRESS :String = "buttonPress";
   public static var RELEASE :String = "buttonRelease";
   public static var RELEASE_OUTSIDE :String = "buttonReleaseOutside";
   public static var HOVER_ON :String = "buttonHoverOn";
   public static var HOVER_OFF :String = "buttonHoverOff";

   public function ButtonEvent( type :String, target :Object ) {
      super( type, target );
   }

}