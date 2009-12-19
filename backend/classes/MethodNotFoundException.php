<?php
class MethodNotFoundException extends Exception {
   public function __construct( $methodName ) {
      parent::__construct( 'Method not found: ' . $methodName );
      $this->methodName = $methodName;
   }

   public function getMethodName() {
      return $this->methodName;
   }

   private $methodName;
}
?>