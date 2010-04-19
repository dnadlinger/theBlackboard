import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IBackendOperation;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.controller.auth.AuthOperationDecorator;
import at.klickverbot.theBlackboard.controller.auth.IAuthenticator;
import at.klickverbot.theBlackboard.controller.auth.IAuthenticatorProvider;
import at.klickverbot.theBlackboard.service.IAuthService;
import at.klickverbot.theBlackboard.service.IOperationFilter;

class at.klickverbot.theBlackboard.controller.auth.AuthHandler extends CoreObject
   implements IOperationFilter, IAuthenticatorProvider {

   /**
    * Constructor.
    */
   public function AuthHandler( authService :IAuthService ) {
      m_authService = authService;
      m_authenticators = new Object();
   }

   public function filterOperation( target :IOperation ) :IOperation {
      if ( target instanceof IBackendOperation ) {
         var backendOperation :IBackendOperation = IBackendOperation( target );
         return new AuthOperationDecorator( backendOperation, m_authService, this );
      } else {
         // If the operation is not known to the backend, we have no chance to
         // authenticate it.
         return target;
      }
   }

   public function getAuthenticatorByName( name :String ) :IAuthenticator {
      return m_authenticators[ name ];
   }

   public function setAuthenticator( name :String, to :IAuthenticator ) :Void {
      m_authenticators[ name ] = to;
   }

   private var m_authService :IAuthService;
   private var m_authenticators :Object;
}
