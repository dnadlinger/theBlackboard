import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigLocationBackend;

class at.klickverbot.theBlackboard.service.backend.ConfigLocationXmlBackend
   extends CoreObject implements IConfigLocationBackend {

   /**
    * Constructor.
    */
   public function ConfigLocationXmlBackend( url :String ) {
      m_url = url;
   }

   public function getConfigLocation() :IOperation {
      return new XmlOperation( m_url, null );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "url: " + m_url );
   }

   private var m_url :String;
}
