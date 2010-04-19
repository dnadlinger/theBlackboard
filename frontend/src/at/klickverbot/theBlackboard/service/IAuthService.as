import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.IAuthService extends ICoreInterface {
   public function getAuthSetsForMethod( methodId :String ) :IOperation;
}
