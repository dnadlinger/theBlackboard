<?php
class CaptchaImageResponse extends Response {
   public function writeOutput() {
      if ( $this->isFault() ) {
         error_log( 'Error while handling captcha image request: ' .
            $this->faultString . ' (' . $this->faultCode . ')' );
         header( 'HTTP/1.1 500 Internal Server Error' );
         die( '500 Internal Server Error' );
      }

      $outputWidth = 150;
      $outputHeight = 40;

      $maxRotation = 30;
      $minSize = 15;
      $maxSize = 25;
      $backgroundCharCount = 45;
      $font = PathBuilder::getInstance()->buildAbsolutePath(
         Constants::ASSET_DIR, Constants::CAPTCHA_FONT );

      $image = imagecreatetruecolor( $outputWidth, $outputHeight );

      $backColor = imagecolorallocate( $image,
         $this->randInt( 224, 255 ), $this->randInt( 244, 255 ), $this->randInt( 224, 255 ) );
      imagefilledrectangle( $image, 0, 0, $outputWidth, $outputHeight, $backColor );

      for( $i = 0; $i < $backgroundCharCount; ++$i ) {
         $size = $this->randInt( $minSize / 2.3, $maxSize / 1.7 );
         $angle = $this->randInt( 0, 359 );
         $x = $this->randInt( 0, $outputWidth );
         $y = $this->randInt( 0, ( $outputHeight - ( $size / 5 ) ) );
         $color = imagecolorallocate( $image,
            $this->randInt( 120, 224 ), $this->randInt( 120, 224 ), $this->randInt( 120, 224 ) );
         $char = chr( $this->randInt( 33, 126 ) );
         imagettftext( $image, $size, $angle, $x, $y, $color, $font, $char );
      }

      $x = $this->randInt( $minSize * 0.7, $maxSize * 0.7 );
      for( $i = 0; $i < strlen( $this->returnValue->getValue() ); ++$i ) {
         $char = substr( $this->returnValue->getValue(), $i, 1 );

         $angle = $this->randInt( -$maxRotation, $maxRotation );
         $size = $this->randInt( $minSize, $maxSize );
         $y = $this->randInt( $size, ( $outputHeight - ( $size / 7 ) ) );

         $color = imagecolorallocate( $image, $this->randInt( 0, 127 ), $this->randInt( 0, 127 ), $this->randInt( 0, 127 ) );
         $shadow = imagecolorallocate( $image, $this->randInt( 127, 255 ), $this->randInt( 127, 255 ), $this->randInt( 127, 255 ) );

         imagettftext( $image, $size, $angle, $x + (int)($size / 15), $y, $shadow, $font, $char );
         imagettftext( $image, $size, $angle, $x, $y - (int)($size / 15), $color, $font, $char );
         $x += (int)( $size + ( $minSize / 6 ) );
      }

      header( 'Content-Type: image/png' );
      imagepng( $image );

      imagedestroy( $image );
   }

   private function randInt( $min, $max ) {
      srand( (double)microtime() * 1000000 );
      return intval( rand( $min, $max ) );
   }
}
?>