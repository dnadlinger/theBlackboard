import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.IConfigLocationService;
import at.klickverbot.rpc.XmlOperation;

class at.klickverbot.theBlackboard.service.XmlConfigLocationService extends CoreObject
   implements IConfigLocationService {

   /**
    * Constructor.
    */
   public function XmlConfigLocationService( url :String ) {
      m_url = url;
   }

   public function getConfigLocation() :IOperation {
      return new XmlOperation( m_url, null );
   }

   private var m_url :String;
}
