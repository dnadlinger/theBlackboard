<?php
class CaptchaImageRequest extends Request {
   protected function init() {
      $this->methodOwner = 'captchaAuth';
      $this->methodName = 'getSolution';
      $this->methodParams = $_GET[ 'id' ];

      // TODO: Where to call session_start?
      session_start();
      $this->session = new PhpHttpSession();
   }
}
?>