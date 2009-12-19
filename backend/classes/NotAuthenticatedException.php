<?php
class NotAuthenticatedException extends Exception {
   public function __construct() {
      parent::__construct( "Authentication is needed to call this method.",
         FaultCodes::AUTHENTICATION_NEEDED );
   }
}
?>