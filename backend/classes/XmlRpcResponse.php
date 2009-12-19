<?php
require_once( PathBuilder::getInstance()->buildAbsolutePath(
   Constants::LIBS_DIR, Constants::LIBS_FILE_XMLRPC ) );

class XmlRpcResponse extends Response {
   public function writeOutput() {
      if ( $this->isFault() ) {
         XMLRPC_error( $this->faultCode, $this->faultString );
      } elseif ( $this->returnValue == null ) {
         // TODO: Can we return nothing throuh xmlrpc?
         // TODO: Why is XMLRPC_prepare going nuts with an empty string passed?
         XMLRPC_response( XMLRPC_prepare( "void" ) );
      } else {
         $type = $this->returnValue->getType();
         if ( $type == Types::DATE ) {
            $convertedValue = XMLRPC_convert_timestamp_to_iso8601( $this->returnValue->getValue() );
         } else {
            $convertedValue = $this->returnValue->getValue();
         }
         XMLRPC_response( XMLRPC_prepare( $convertedValue ) );
      }
   }
}
?>