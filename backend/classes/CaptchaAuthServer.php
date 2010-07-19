<?php
class CaptchaAuthServer {
   public function __construct( CaptchaAuth $wrappedCaptchaAuth ) {
      $this->captchaAuth = $wrappedCaptchaAuth;
   }

   public function getCaptcha( Request $request ) {
      $params = $request->getMethodParams();
      MethodUtils::checkSignature( array( Types::STRING ), $params );

      $parts = explode( '.', $params[ 0 ] );

      if ( count( $parts ) != 2 || ( count_chars( $parts[ 0 ] ) < 1 ) ||
         ( count_chars( $parts[ 1 ] ) < 1 ) ) {
         throw new InvalidParameterException( 'methodId must consist of an ' .
            'owner object and a method name separated by a single dot.' );
      }

      $captchaId = call_user_func_array(
         array( $this->captchaAuth, 'getCaptcha' ), $parts );

      $ids = $request->getSession()->getValue( SessionValues::CAPTCHA_IDS );
      if ( $ids == null ) {
         $ids = array();
      }
      $ids[] = $captchaId;
      $request->getSession()->setValue( SessionValues::CAPTCHA_IDS, $ids );

      return new ReturnValue( $captchaId );
   }

   public function solveCaptcha( Request $request ) {
      $params = $request->getMethodParams();
      MethodUtils::checkSignature( array( Types::INT, Types::STRING ), $params );
      call_user_func_array( array( $this->captchaAuth, 'solveCaptcha' ), $params );
   }

   private $captchaAuth;
}
?>