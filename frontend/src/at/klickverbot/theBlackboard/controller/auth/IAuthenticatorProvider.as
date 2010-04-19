import at.klickverbot.theBlackboard.controller.auth.IAuthenticator;
import at.klickverbot.core.ICoreInterface;

interface at.klickverbot.theBlackboard.controller.auth.IAuthenticatorProvider extends ICoreInterface {
   public function getAuthenticatorByName( methodString :String ) :IAuthenticator;
}
