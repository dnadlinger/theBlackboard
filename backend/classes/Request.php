<?php
abstract class Request {
   public final function __construct() {
      $this->methodOwner = null;
      $this->methodName = null;
      $this->methodParams = null;
      $this->session = null;

      $this->init();
   }

   public final function isValid() {
      return !( StringUtils::isEmpty( $this->methodOwner ) ||
         StringUtils::isEmpty( $this->methodName ) || $this->session == null );
   }

   public final function getMethodOwner() {
      return $this->methodOwner;
   }
   public final function getMethodName() {
      return $this->methodName;
   }
   public final function getMethodParams() {
      return $this->methodParams;
   }

   public final function getSession() {
      return $this->session;
   }

   abstract protected function init();

   protected $methodOwner;
   protected $methodName;
   protected $methodParams;
   protected $session;
}
?>