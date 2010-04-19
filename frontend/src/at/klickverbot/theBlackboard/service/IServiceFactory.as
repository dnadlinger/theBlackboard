import at.klickverbot.core.ICoreInterface;
import at.klickverbot.theBlackboard.service.IAuthService;
import at.klickverbot.theBlackboard.service.IConfigLocationService;
import at.klickverbot.theBlackboard.service.IConfigService;
import at.klickverbot.theBlackboard.service.IEntriesService;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ICaptchaAuthService;

interface at.klickverbot.theBlackboard.service.IServiceFactory extends ICoreInterface {
   public function createConfigLocationService(
      filters :Array ) :IConfigLocationService;
   public function createConfigService( location :ServiceLocation,
      filters :Array ) :IConfigService;
   public function createAuthService( location :ServiceLocation,
      filters :Array ) :IAuthService;
   public function createEntriesService( location :ServiceLocation,
      filters :Array ) :IEntriesService;
   public function createCaptchaAuthService( location :ServiceLocation,
      filters :Array ) :ICaptchaAuthService;
}
