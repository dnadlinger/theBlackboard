import at.klickverbot.debug.Logger;
import at.klickverbot.debug.Debug;
import at.klickverbot.theBlackboard.controller.auth.IAuthenticator;
import at.klickverbot.theBlackboard.controller.auth.IAuthenticatorProvider;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IBackendOperation;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.BackendFaultCodes;
import at.klickverbot.theBlackboard.service.IAuthService;

class at.klickverbot.theBlackboard.controller.auth.AuthOperationDecorator
   extends EventDispatcher implements IOperation {

   public function AuthOperationDecorator( backendOperation :IBackendOperation,
      authService :IAuthService, authenticatorProvider :IAuthenticatorProvider ) {
      m_backendOperation = backendOperation;
      m_authService = authService;
      m_authenticatorProvider = authenticatorProvider;

      m_authSets = null;
   }

   public function execute() :Void {
      Debug.assertNull( m_authSets, "AuthOperationDecorator.execute must not " +
         "be called twice in the current implementation" );

      m_backendOperation.addEventListener( ResultEvent.RESULT, this, dispatchEvent );
      m_backendOperation.addEventListener( FaultEvent.FAULT, this, handleFault );
      m_backendOperation.execute();
   }

   private function handleFault( event :FaultEvent ) :Void {
      if ( event.faultCode == BackendFaultCodes.AUTHENTICATION_NEEDED ) {
         if ( m_authSets == null ) {
            // The auth sets for the backend operation have not been queried yet.
            var authSetsOperation :IOperation =
               m_authService.getAuthSetsForMethod( m_backendOperation.getBackendMethodId() );
            authSetsOperation.addEventListener( ResultEvent.RESULT, this, handleSetsResult );
            authSetsOperation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
            authSetsOperation.execute();
         } else {
            // If there are still sets available, try the next one, otherwise
            // just propagate the error.
            if ( m_authSets.length > 0 ) {
               tryCurrentSet();
            } else {
               dispatchEvent( event );
            }
         }
      } else {
         dispatchEvent( event );
      }
   }

   private function handleSetsResult( event :ResultEvent ) :Void {
      m_authSets = Array( event.result );
      tryCurrentSet();
   }

   private function tryCurrentSet() :Void {
      if ( m_authSets.length > 0 ) {
         processCurrentSet();
      } else {
         // Execute the backend operation again to error out with the original
         // fault event.
         m_backendOperation.execute();
      }
   }

   private function processCurrentSet() :Void {
      var currentSet :Array = m_authSets[ 0 ];

      if ( currentSet.length == 0 ) {
         // The current set is empty or has already been emptied, try to execute
         // the backend operation again.
         m_authSets.shift();
         m_backendOperation.execute();
      }

      var authenticators :Array = new Array();

      var currentMethodName :String;
      var i :Number = currentSet.length;
      while ( currentMethodName = currentSet[ --i ] ) {
         var authenticator :IAuthenticator =
           m_authenticatorProvider.getAuthenticatorByName( currentMethodName );

         if ( authenticator == null ) {
            Logger.getLog( "AuthOperationDecorator" ).debug(
              "IAuthenticationProvider has no authenticator for '" +
              currentMethodName + "' for: " + this );
            break;
         }

         authenticators.push( authenticator );
      }

      if ( authenticators.length == currentSet.length ) {
         // The current auth set was valid in the sense that we have an
         // authenticator registered for every method name in it.
         currentSet.shift();

         var authOperation :IOperation =
            IAuthenticator( authenticators[ 0 ] ).authenticate( m_backendOperation );
         authOperation.addEventListener( ResultEvent.RESULT, this, processCurrentSet );
         authOperation.addEventListener( FaultEvent.FAULT, this, handleAuthFail );
         authOperation.execute();
      } else {
         // It is invalid, skip it and try the next one.
         m_authSets.shift();
         tryCurrentSet();
      }
   }

   private function handleAuthFail( event :FaultEvent ) :Void {
      m_authSets.shift();
      tryCurrentSet();
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(
         "backendOperation: " + m_backendOperation );
   }

   private var m_backendOperation :IBackendOperation;
   private var m_authService :IAuthService;
   private var m_authenticatorProvider :IAuthenticatorProvider;

   private var m_authSets :Array;
}
