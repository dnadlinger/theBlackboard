import at.klickverbot.core.CoreObject;
import at.klickverbot.theBlackboard.controller.auth.CaptchaAuthenticatorOperation;
import at.klickverbot.theBlackboard.model.CaptchaRequest;

/**
 * Helper class for creating a CaptchaRequest->CaptchaAuthenticatorOperation
 * hash.
 */
class at.klickverbot.theBlackboard.controller.auth.OperationForCaptchaRequest
   extends CoreObject {

   /**
    * Constructor.
    */
   public function OperationForCaptchaRequest( request :CaptchaRequest,
      operation :CaptchaAuthenticatorOperation ) {
      m_request = request;
      m_operation = operation;
   }

   public function get request() :CaptchaRequest {
      return m_request;
   }
   public function set request( to :CaptchaRequest ) :Void {
      m_request = to;
   }

   public function get operation() :CaptchaAuthenticatorOperation {
      return m_operation;
   }
   public function set operation( to :CaptchaAuthenticatorOperation ) :Void {
      m_operation = to;
   }

   private var m_request :CaptchaRequest;
   private var m_operation :CaptchaAuthenticatorOperation;
}
