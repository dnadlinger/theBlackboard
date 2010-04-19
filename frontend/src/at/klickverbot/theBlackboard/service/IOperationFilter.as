import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.IOperationFilter extends ICoreInterface {
   public function filterOperation( target :IOperation ) :IOperation;
}
