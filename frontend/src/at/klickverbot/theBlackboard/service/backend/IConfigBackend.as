import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.backend.IConfigBackend
   extends ICoreInterface {

   public function getAll() :IOperation;
}