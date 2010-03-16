import at.klickverbot.core.ICoreInterface;
import at.klickverbot.theBlackboard.service.IConfigLocationService;
import at.klickverbot.theBlackboard.service.IConfigService;
import at.klickverbot.theBlackboard.service.IEntriesService;
import at.klickverbot.theBlackboard.service.ServiceLocation;

interface at.klickverbot.theBlackboard.service.IServiceFactory extends ICoreInterface {
   public function createConfigLocationService() :IConfigLocationService;
   public function createConfigService( location :ServiceLocation )
      :IConfigService;
   public function createEntriesService( location :ServiceLocation )
      :IEntriesService;
}
