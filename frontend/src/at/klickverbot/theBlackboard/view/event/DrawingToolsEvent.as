import at.klickverbot.event.events.Event;

class at.klickverbot.theBlackboard.view.event.DrawingToolsEvent extends Event {
   public static var CHANGE_TOOL :String = "drawingToolsTool";
   public static var CHANGE_COLOR :String = "drawingToolsColor";
   public static var CHANGE_SIZE :String = "drawingToolsSize";

   public function DrawingToolsEvent( type :String, target :Object, value :Object ) {
      super( type, target );

      m_value = value;
   }

   public function get value() :Object {
      return m_value;
   }

   private var m_value :Object;
}
