<?php
interface IAuthHandler {
   public function isAuthenticated( Request $request );
}
?>