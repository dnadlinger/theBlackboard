<?php
class CaptchaAuthHandler implements IAuthHandler {
   public function __construct( CaptchaAuth $captchaAuth ) {
      $this->captchaAuth = $captchaAuth;
   }

   public function isAuthenticated( Request $request ) {
      return $this->captchaAuth->isAuthenticated(
         $request->getMethodOwner(), $request->getMethodName(),
         $request->getSession()->getValue( SessionValues::CAPTCHA_IDS )
      );
   }

   private $captchaAuth;
}
?>