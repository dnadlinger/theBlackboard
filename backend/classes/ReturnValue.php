<?php
class ReturnValue {
   public function __construct( $value, $type = null ) {
      $this->value = $value;
      $this->type = $type;
   }

   public function getValue() {
      return $this->value;
   }
   public function setValue( $newValue ) {
      $this->value = $newValue;
   }

   public function getType() {
      return $this->type;
   }
   public function setType( $newType ) {
      $this->type = $newType;
   }

   protected $value;
   protected $type;
}
?>