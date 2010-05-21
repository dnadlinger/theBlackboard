<?php
class CaptchaImageRequest extends Request {
   protected function init() {
      $this->methodOwner = 'captchaAuth';
      $this->methodName = 'getSolution';
      $this->methodParams = $_GET[ 'id' ];
   }
}
?>