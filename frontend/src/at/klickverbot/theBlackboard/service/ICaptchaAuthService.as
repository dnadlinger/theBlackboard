import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.ICaptchaAuthService extends ICoreInterface {
   public function getCaptcha( methodId :String ) :IOperation;
   public function solveCaptcha( id :Number, solution :String ) :IOperation;
}
