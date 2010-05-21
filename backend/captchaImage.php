<?php
require_once( 'Constants.php' );
require_once( Constants::CLASSES_DIR . DIRECTORY_SEPARATOR . 'Core.php' );

$core = new Core( realpath( dirname( __FILE__ ) ) );
$core->getFrontController()->handleRequest( new CaptchaImageProtocol() );
?>