<?php
abstract class Response {
   public function __construct() {
      $this->returnValue = null;
      $this->faultCode = null;
      $this->faultString = null;
   }

   public function setReturnValue( ReturnValue $value ) {
      $this->returnValue = $value;
   }

   public function setFault( $code, $string ) {
      $this->faultCode = $code;
      $this->faultString = $string;
   }

   public function isFault() {
      return ( $this->faultCode != null ) && ( $this->faultString != null );
   }

   abstract public function writeOutput();

   protected $returnValue;
   protected $faultCode;
   protected $faultString;
}
?>