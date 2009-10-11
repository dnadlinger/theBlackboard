import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.DrawingAreaEvent extends Event {
   public static var OP_COMPLETED :String = "daLineCompleted";
   public static var HISTORY_CHANGE :String = "daHistoryChange";

   public function DrawingAreaEvent( type :String, target :Object,
      undoSteps :Number, redoSteps :Number ) {

      super( type, target );

      m_undoSteps = undoSteps;
      m_redoSteps = redoSteps;
   }

   public function get undoSteps() :Number {
      return m_undoSteps;
   }

   public function get redoSteps() :Number {
      return m_redoSteps;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "undoSteps: " + m_undoSteps,
         "redoSteps: " + m_redoSteps
      ] );
   }

   private var m_undoSteps :Number;
   private var m_redoSteps :Number;
}