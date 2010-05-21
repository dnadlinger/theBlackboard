import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.ICaptchaAuthService;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.backend.ICaptchaAuthBackend;

class at.klickverbot.theBlackboard.service.adapter.CaptchaAuthAdapter
   extends CoreObject implements ICaptchaAuthService {

   public function CaptchaAuthAdapter( backend :ICaptchaAuthBackend,
      backendFilters :Array ) {

      m_backend = backend;
      m_backendFilters = backendFilters;
   }

   public function getCaptcha( methodId :String ) :IOperation {
      return new AdapterOperation( m_backend.getCaptcha( methodId ),
         m_backendFilters );
   }

   public function solveCaptcha( id :Number, solution :String ) :IOperation {
      return new AdapterOperation( m_backend.solveCaptcha( id, solution ),
         m_backendFilters );
   }

   private var m_backend :ICaptchaAuthBackend;
   private var m_backendFilters :Array;
}
