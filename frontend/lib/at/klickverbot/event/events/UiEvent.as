import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.UiEvent extends Event {
   public static var MOUSE_OVER :String = "uiMouseOn";
   public static var MOUSE_OUT :String = "uiMouseOut";

   public function UiEvent( type :String, target :Object ) {
      super( type, target );
   }
}
