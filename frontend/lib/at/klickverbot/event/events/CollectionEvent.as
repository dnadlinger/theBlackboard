import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.CollectionEvent extends Event {
   public static var CHANGE :String = "listChange";

   public function CollectionEvent( type :String, target :Object ) {
      super( type, target );
   }
}
