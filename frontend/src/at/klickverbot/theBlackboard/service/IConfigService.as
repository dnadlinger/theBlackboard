import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.IConfigService extends ICoreInterface {
   public function loadConfig() :IOperation;
}
