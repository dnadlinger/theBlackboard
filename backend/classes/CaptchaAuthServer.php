<?php
class CaptchaAuthServer {
   public function __construct( CaptchaAuth $wrappedCaptchaAuth ) {
      $this->captchaAuth = $wrappedCaptchaAuth;
   }

   public function getCaptcha( array $params ) {
      MethodUtils::checkSignature( array( Types::STRING ), $params );

      $parts = explode( '.', $params[ 0 ] );

      if ( count( $parts ) != 2 || ( count_chars( $parts[ 0 ] ) < 1 ) ||
         ( count_chars( $parts[ 1 ] ) < 1 ) ) {
         throw new InvalidParameterException( 'methodId must consist of an ' .
            'owner object and a method name separated by a single dot.' );
      }

      return new ReturnValue( call_user_func_array(
         array( $this->captchaAuth, 'getCaptcha' ), $parts ) );
   }

   public function solveCaptcha( array $params ) {
      MethodUtils::checkSignature( array( Types::INT, Types::STRING ), $params );
      call_user_func_array( array( $this->captchaAuth, 'solveCaptcha' ), $params );
   }

   private $captchaAuth;
}
?>