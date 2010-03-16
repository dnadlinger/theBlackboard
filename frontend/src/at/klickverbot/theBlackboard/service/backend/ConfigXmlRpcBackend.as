import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlRpcOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigBackend;

class at.klickverbot.theBlackboard.service.backend.ConfigXmlRpcBackend extends CoreObject
   implements IConfigBackend {

   /**
    * Constructor.
    */
   public function ConfigXmlRpcBackend( url :String ) {
      m_url = url;
   }

   public function getAll() :IOperation {
      return new XmlRpcOperation( m_url, "configuration.getAll", [] );
   }

// Unused in the client.
//	public function getByName( keyName :String ) :IOperation {
//		return new XmlRpcOperation( m_url, "configuration.getByName", [ keyName ] );
//	}

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "url: " + m_url );
   }

   private var m_url :String;
}
