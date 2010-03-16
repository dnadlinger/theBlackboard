import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.backend.IConfigLocationBackend
   extends ICoreInterface {

   public function getConfigLocation() :IOperation;
}