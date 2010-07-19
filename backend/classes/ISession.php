<?php
interface ISession {
   public function getValue( $key );
   public function setValue( $key, $value );
}
?>