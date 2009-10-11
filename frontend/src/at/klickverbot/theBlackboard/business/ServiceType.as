import at.klickverbot.core.CoreObject;

class at.klickverbot.theBlackboard.business.ServiceType extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ServiceType() {
   }

   public static var PLAIN_XML :ServiceType = new ServiceType();
   public static var XML_RPC :ServiceType = new ServiceType();
   public static var LOCAL :ServiceType = new ServiceType();
}
