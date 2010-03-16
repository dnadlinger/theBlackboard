import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigBackend;

class at.klickverbot.theBlackboard.service.backend.ConfigXmlBackend extends CoreObject
   implements IConfigBackend {

   /**
    * Constructor.
    */
   public function ConfigXmlBackend( url :String ) {
      m_url = url;
   }

   public function getAll() :IOperation {
      return new XmlOperation( m_url, null );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "url: " + m_url );
   }

   private var m_url :String;
}
