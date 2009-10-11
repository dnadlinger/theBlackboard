import at.klickverbot.core.CoreObject;

class at.klickverbot.external.xmlrpc.MethodFault extends CoreObject {
   /**
    * Constructor.
    */
   public function MethodFault( faultCode :Number, faultString :String ) {
      m_faultCode = faultCode;
      m_faultString = faultString;
   }

   public function get faultCode() :Number {
      return m_faultCode;
   }
   public function set faultCode( to :Number ) :Void {
      m_faultCode = to;
   }

   public function get faultString() :String {
      return m_faultString;
   }
   public function set faultString( to :String ) :Void {
      m_faultString = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "faultCode: " + m_faultCode,
         "faultString: " + m_faultString
      ] );
   }

   private var m_faultCode :Number;
   private var m_faultString :String;
}