<?php
class ConfigKeyNotFoundException extends Exception {
   public function __construct( $keyName ) {
      parent::__construct( 'Configuration key not found: ' . $keyName );
      $this->keyName = $keyName;
   }

   public function getKeyName() {
      return $this->keyName;
   }

   private $keyName;
}
?>