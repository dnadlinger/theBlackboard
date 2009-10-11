import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.TimerEvent extends Event {
   public static var TIMER :String = "tiTimer";

   public function TimerEvent( type :String, target :Object, triggeringCount :Number ) {
      super( type, target );
      m_triggeringCount = triggeringCount;
   }

   public function get triggeringCount() :Number {
      return m_triggeringCount;
   }

   private var m_triggeringCount :Number;
}