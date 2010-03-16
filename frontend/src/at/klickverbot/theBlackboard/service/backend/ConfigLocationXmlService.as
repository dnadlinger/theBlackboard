import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigLocationService;

class at.klickverbot.theBlackboard.service.backend.ConfigLocationXmlService extends CoreObject
   implements IConfigLocationService {

   /**
    * Constructor.
    */
   public function ConfigLocationXmlService( url :String ) {
      m_url = url;
   }

   public function getConfigLocation() :IOperation {
      return new XmlOperation( m_url, null );
   }

   private var m_url :String;
}
