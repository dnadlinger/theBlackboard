import at.klickverbot.core.CoreObject;
import at.klickverbot.theBlackboard.service.ServiceType;

class at.klickverbot.theBlackboard.service.ServiceLocation extends CoreObject {
   /**
    * Constructor.
    */
   public function ServiceLocation( type :ServiceType, info :Object ) {
      m_type = type;
      m_info = info;
   }

   public function get type() :ServiceType {
      return m_type;
   }
   public function set type( to :ServiceType ) :Void {
      m_type = to;
   }

   public function get info() :Object {
      return m_info;
   }
   public function set info( to :Object ) :Void {
      m_info = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "type: " + m_type,
         "info: " + m_info ] );
   }

   private var m_type :ServiceType;
   private var m_info :Object;
}
