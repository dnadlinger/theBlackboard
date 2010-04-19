import at.klickverbot.event.events.Event;
import at.klickverbot.theBlackboard.model.CaptchaRequest;

class at.klickverbot.theBlackboard.view.event.CaptchaAuthViewEvent extends Event {
   public static var SOLVE :String = "captchaAuthViewSolve";

   public function CaptchaAuthViewEvent( type :String, target :Object,
      request :CaptchaRequest, solution :String ) {

      super( type, target );
      m_request = request;
      m_solution = solution;
   }

   public function get request() :CaptchaRequest {
      return m_request;
   }

   public function get solution() :String {
      return m_solution;
   }

   private var m_request :CaptchaRequest;
   private var m_solution :String;
}
