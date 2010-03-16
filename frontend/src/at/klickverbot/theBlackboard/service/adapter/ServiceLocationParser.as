import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.service.ServiceType;

class at.klickverbot.theBlackboard.service.adapter.ServiceLocationParser
   extends CoreObject {

   public function parseTypeString( type :String ) :ServiceType {
      var result :ServiceType = null;

      if ( type == "xml" ) {
         result = ServiceType.XML;
      } else if ( type == "xml-rpc" ) {
         result = ServiceType.XML_RPC;
      } else if ( type == "local" ) {
         result = ServiceType.LOCAL;
      }

      if ( type == null ) {
         Logger.getLog( "ServiceLocationParser" ).warn( "Unknown service type: " +
            type + ". Valid types are: xml, xml-rpc, local." );
      }

      return result;
   }
}
