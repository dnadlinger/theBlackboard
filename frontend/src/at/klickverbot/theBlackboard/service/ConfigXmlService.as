import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlOperation;
import at.klickverbot.theBlackboard.service.IConfigService;

class at.klickverbot.theBlackboard.service.ConfigXmlService extends CoreObject
   implements IConfigService {

   /**
    * Constructor.
    */
   public function ConfigXmlService( url :String ) {
      m_url = url;
   }

   public function getAll() :IOperation {
      return new XmlOperation( m_url, null );
   }

   private var m_url :String;
}