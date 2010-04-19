import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlRpcOperation;
import at.klickverbot.theBlackboard.service.backend.IAuthBackend;

class at.klickverbot.theBlackboard.service.backend.AuthXmlRpcBackend extends CoreObject
   implements IAuthBackend {

   /**
    * Constructor.
    */
   public function AuthXmlRpcBackend( url :String ) {
      m_url = url;
   }

   public function getAuthSetsForMethod( methodId :String ) :IOperation {
      return new XmlRpcOperation( m_url,
         "auth.getAuthSetsForMethod", [ methodId ] );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "url: " + m_url );
   }

   private var m_url :String;
}
