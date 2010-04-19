import at.klickverbot.theBlackboard.model.CaptchaRequest;
import at.klickverbot.event.events.Event;

class at.klickverbot.theBlackboard.controller.auth.CaptchaAuthenticatorOperationEvent extends Event {
   public static var REQUEST :String = "captchaAuthRequest";

   public function CaptchaAuthenticatorOperationEvent( type :String,
      target :Object, request :CaptchaRequest ) {

      super( type, target );
      m_request = request;
   }

   public function get request() :CaptchaRequest {
      return m_request;
   }

   private var m_request :CaptchaRequest;
}
