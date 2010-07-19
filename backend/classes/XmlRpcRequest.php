<?php
require_once( PathBuilder::getInstance()->buildAbsolutePath(
   Constants::LIBS_DIR, Constants::LIBS_FILE_XMLRPC ) );

class XmlRpcRequest extends Request {
   protected function init() {
      $requestString = file_get_contents( 'php://input' );

      if ( StringUtils::isEmpty( $requestString ) ) {
         return;
      }

      $requestData = XMLRPC_parse( $requestString );

      $methodStrings = explode( '.', XMLRPC_getMethodName( $requestData ) );
      $this->methodOwner = $methodStrings[ 0 ];
      $this->methodName = $methodStrings[ 1 ];

      $this->methodParams = XMLRPC_getParams( $requestData );

      // TODO: Where to call session_start?
      session_start();
      $this->session = new PhpHttpSession();
   }
}
?>