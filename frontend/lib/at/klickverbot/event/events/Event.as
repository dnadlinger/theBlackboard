import at.klickverbot.core.CoreObject;

class at.klickverbot.event.events.Event extends CoreObject {
   public static var COMPLETE :String = "complete";
   public static var EXTERN_FAILED :String = "externFailed";

   public static var ENTER_FRAME :String = "enterFrame";

   public function Event( type: String, target :Object ) {
      m_type = type;
      m_target = target;
   }

   public function get type() :String {
      return m_type;
   }

   public function get target() :Object {
      return m_target;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "type: " + m_type,
         "target: " + m_target
      ] );
   }

   private var m_type :String;
   private var m_target :Object;
}
