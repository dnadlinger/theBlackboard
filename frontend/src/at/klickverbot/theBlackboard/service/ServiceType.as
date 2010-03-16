import at.klickverbot.core.CoreObject;

class at.klickverbot.theBlackboard.service.ServiceType extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ServiceType( name :String ) {
      m_name = name;
   }

   public static var XML :ServiceType = new ServiceType( "xml" );
   public static var XML_RPC :ServiceType = new ServiceType( "xml-rpc" );
   public static var LOCAL :ServiceType = new ServiceType( "local" );

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_name );
   }

   private var m_name :String;
}
