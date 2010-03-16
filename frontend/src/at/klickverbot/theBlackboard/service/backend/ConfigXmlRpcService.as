import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlRpcOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigService;

class at.klickverbot.theBlackboard.service.backend.ConfigXmlRpcService extends CoreObject
   implements IConfigService {

   /**
    * Constructor.
    */
   public function ConfigXmlRpcService( url :String ) {
      m_url = url;
   }

   public function getAll() :IOperation {
      return new XmlRpcOperation( m_url, "configuration.getAll", [] );
   }

// Unused in the client.
//	public function getByName( keyName :String ) :IOperation {
//		return new XmlRpcOperation( m_url, "configuration.getByName", [ keyName ] );
//	}

   private var m_url :String;
}