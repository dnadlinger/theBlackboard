<?php
class AuthServer {
   public function __construct( Authenticator $wrappedAuthenticator ) {
      $this->authenticator = $wrappedAuthenticator;
   }

   public function getAuthSetsForMethod( Request $request ) {
      $params = $request->getMethodParams();
      MethodUtils::checkSignature( array( Types::STRING ), $params );

      $parts = explode( '.', $params[ 0 ] );

      if ( count( $parts ) != 2 || ( count_chars( $parts[ 0 ] ) < 1 ) ||
         ( count_chars( $parts[ 1 ] ) < 1 ) ) {
         throw new InvalidParameterException( 'methodId must consist of an ' .
            'owner object and a method name separated by a single dot.' );
      }

      return new ReturnValue( call_user_func_array(
         array( $this->authenticator, 'getAuthSetsForMethod' ), $parts ) );
   }

   private $authenticator;
}
?>