import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.external.xmlrpc.DataType;

class at.klickverbot.external.xmlrpc.Data extends CoreObject {
   /**
    * Constructor.
    */
   public function Data( value :Object, type :DataType ) {
      this.value = value;
      this.type = type;
   }

   public function get value() :Object {
      return m_value;
   }
   public function set value( to :Object ) :Void {
      Debug.assertNotNull( to, "Value must not be null!" );
      m_value = to;
   }

   public function get type() :DataType {
      return m_type;
   }
   public function set type( to :DataType ) :Void {
      Debug.assertNotNull( to, "Type must not be null!" );
      m_type = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "value: " + m_value,
         "type: " + m_type
      ] );
   }

   private var m_value :Object;
   private var m_type :DataType;
}