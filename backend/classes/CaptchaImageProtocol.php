<?php
class CaptchaImageProtocol implements IProtocol {
   public function createRequest() {
      return new CaptchaImageRequest();
   }

   public function createResponse() {
      return new CaptchaImageResponse();
   }
}
?>