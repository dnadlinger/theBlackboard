<?php
class CaptchaAuthHandler implements IAuthHandler {
   public function __construct( CaptchaAuth $captchaAuth ) {
      $this->captchaAuth = $captchaAuth;
   }

   public function isAuthenticated( $methodOwner, $methodName ) {
      return $this->captchaAuth->isAuthenticated( $methodOwner, $methodName );
   }

   private $captchaAuth;
}
?>