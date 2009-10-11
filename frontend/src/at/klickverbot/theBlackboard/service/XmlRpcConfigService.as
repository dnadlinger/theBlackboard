import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.IConfigService;
import at.klickverbot.rpc.XmlRpcOperation;

class at.klickverbot.theBlackboard.service.XmlRpcConfigService extends CoreObject
   implements IConfigService {

   /**
    * Constructor.
    */
   public function XmlRpcConfigService( url :String ) {
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
