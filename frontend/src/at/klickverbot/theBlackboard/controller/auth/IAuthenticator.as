import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IBackendOperation;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.controller.auth.IAuthenticator extends ICoreInterface {
   public function authenticate( backendOperation :IBackendOperation ) :IOperation;
}
