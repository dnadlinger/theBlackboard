<?php
class PhpHttpSession implements ISession {
   public function getValue( $key ) {
      return isset( $_SESSION[ $key ] ) ? $_SESSION[ $key ] : null;
   }

   public function setValue( $key, $value ) {
      $_SESSION[ $key ] = $value;
   }
}
?>