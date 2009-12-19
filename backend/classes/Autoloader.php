<?php
class Autoloader {
   public static function init() {
      if ( self::$initialized ) {
         return;
      }

      if ( function_exists( '__autoload') ) {
         spl_autoload_register( '__autoload' );
      }

      spl_autoload_register( array( 'Autoloader', 'loadClass' ) );

      self::$initialized = true;
   }

   public static function loadClass( $className ) {
      if ( class_exists( $className, false ) ||
         interface_exists( $className, false ) ) {
         return;
      }

      $fileName = $className . '.php';

      @include( PathBuilder::getInstance()->buildAbsolutePath(
            Constants::CLASSES_DIR, $fileName ) );

      // Hack to to be able to throw an exception instead of an E_ERROR.
      // (see: http://www.phpbar.de/w/autoload() );
      if ( ( !class_exists( $className, false ) ) &&
         ( !interface_exists( $className, false ) ) ) {
         eval(
            'class ' . $className . ' {' .
            '	public function __construct() {' .
            '		throw new Exception( "Class not found: ' . $className . '" );' .
            '	}' .
            '}'
         );
      }
   }

   private static $initialized = false;
}
?>