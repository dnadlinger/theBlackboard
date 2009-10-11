import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.ResultEvent extends Event {
   public static var RESULT :String = "reResult";

   public function ResultEvent( type :String, target :Object, result :Object ) {
      super( type, target );
      m_result = result;
   }

   public function get result() :Object {
      return m_result;
   }

   private var m_result :Object;
}
