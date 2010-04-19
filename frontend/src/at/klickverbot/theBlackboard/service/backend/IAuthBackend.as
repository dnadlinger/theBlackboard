import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.backend.IAuthBackend
   extends ICoreInterface {

   public function getAuthSetsForMethod( methodId :String ) :IOperation;
}
