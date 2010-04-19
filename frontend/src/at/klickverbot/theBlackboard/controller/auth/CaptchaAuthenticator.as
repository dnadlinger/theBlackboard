import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.Logger;
import at.klickverbot.rpc.IBackendOperation;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.controller.auth.CaptchaAuthenticatorOperation;
import at.klickverbot.theBlackboard.controller.auth.CaptchaAuthenticatorOperationEvent;
import at.klickverbot.theBlackboard.controller.auth.IAuthenticator;
import at.klickverbot.theBlackboard.controller.auth.OperationForCaptchaRequest;
import at.klickverbot.theBlackboard.model.ApplicationModel;
import at.klickverbot.theBlackboard.model.CaptchaRequest;
import at.klickverbot.theBlackboard.service.ICaptchaAuthService;

class at.klickverbot.theBlackboard.controller.auth.CaptchaAuthenticator
   extends CoreObject implements IAuthenticator {

   public function CaptchaAuthenticator( service :ICaptchaAuthService,
      model :ApplicationModel ) {
      m_service = service;
      m_model = model;

      m_requestOperations = new Array();
   }

   public function authenticate( backendOperation :IBackendOperation ) :IOperation {
      var operation :CaptchaAuthenticatorOperation =
         new CaptchaAuthenticatorOperation( m_service, backendOperation.getBackendMethodId() );

      operation.addEventListener( CaptchaAuthenticatorOperationEvent.REQUEST,
         this, pushCaptchaRequest );

      return operation;
   }

   public function solveCaptcha( request :CaptchaRequest, solution :String ) :Void {
      Debug.assertNotNull( request, "The captcha request to solve must not be null!" );

      var currentPair :OperationForCaptchaRequest;
      var i :Number = m_requestOperations.length;
      while ( currentPair = m_requestOperations[ --i ] ) {
         if ( currentPair.request == request ) {
            currentPair.operation.solve( solution );
            return;
         }
      }

      Logger.getLog( "CaptchaAuthenticator" ).error(
         "No auth operation registered for the given captcha request." );
   }

   private function pushCaptchaRequest( event :CaptchaAuthenticatorOperationEvent ) :Void {
      m_requestOperations.push( new OperationForCaptchaRequest(
         event.request, CaptchaAuthenticatorOperation( event.target ) ) );
      m_model.captchaRequests.push( event.request );
   }

   private var m_service :ICaptchaAuthService;
   private var m_model :ApplicationModel;
   private var m_requestOperations :Array;
}
