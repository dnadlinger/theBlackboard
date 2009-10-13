import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.ErrorEvent extends Event {
   public static var ERROR :String = "erError";

   public function ErrorEvent( type :String, target :Object, message :String ) {
      super( type, target );
      m_message = message;
   }

   public function get message() :String {
      return m_message;
   }

   private var m_message :String;
}