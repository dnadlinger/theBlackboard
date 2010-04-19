import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlRpcOperation;
import at.klickverbot.theBlackboard.service.backend.ICaptchaAuthBackend;

class at.klickverbot.theBlackboard.service.backend.CaptchaAuthXmlRpcBackend
   extends CoreObject implements ICaptchaAuthBackend {

   /**
    * Constructor.
    */
   public function CaptchaAuthXmlRpcBackend( url :String ) {
      m_url = url;
   }

   public function getCaptcha( methodId :String ) :IOperation {
      return new XmlRpcOperation( m_url,
         "captchaAuth.getCaptcha", [ methodId ] );
   }

   public function solveCaptcha( id :Number, solution :String ) :IOperation {
      return new XmlRpcOperation( m_url,
         "captchaAuth.solveCaptcha", [ id, solution ] );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "url: " + m_url );
   }

   private var m_url :String;
}
