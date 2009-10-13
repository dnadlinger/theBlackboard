import at.klickverbot.cairngorm.control.CairngormEventDispatcher;
import at.klickverbot.event.events.Event;

class at.klickverbot.cairngorm.control.CairngormEvent extends Event {
   public function CairngormEvent( type :String ) {
      super( type, null );
   }

   public function dispatch() :Void {
      CairngormEventDispatcher.getInstance().dispatchEvent( this );
   }
}
