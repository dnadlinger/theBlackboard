<?php
interface IAuthHandler {
   public function isAuthenticated( $methodOwner, $methodName );
}
?>