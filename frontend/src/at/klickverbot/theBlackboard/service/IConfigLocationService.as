import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.IConfigLocationService
   extends ICoreInterface {

   public function loadConfigLocation() :IOperation;
}
