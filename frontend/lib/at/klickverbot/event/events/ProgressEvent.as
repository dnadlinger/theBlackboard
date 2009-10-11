import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.ProgressEvent extends Event {
   public static var PROGRESS :String = "prProgress";
   public static var COMPLETE :String = "complete";

   public function ProgressEvent( type: String, target :Object,
      percentFinished :Number ) {
      super( type, target );
      m_percentFinished = percentFinished;
   }

   public function get percentFinished() :Number {
      return m_percentFinished;
   }

   private var m_percentFinished :Number;
}