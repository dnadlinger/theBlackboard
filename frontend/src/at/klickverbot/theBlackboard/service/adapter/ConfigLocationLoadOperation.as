import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceType;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigLocationBackend;

class at.klickverbot.theBlackboard.service.adapter.ConfigLocationLoadOperation
   extends AdapterOperation {

   /**
    * Constructor.
    */
   public function ConfigLocationLoadOperation( backend :IConfigLocationBackend ) {
      super( backend.getConfigLocation() );
   }

   private function handleResult( event :ResultEvent ) :Void {
      var type :ServiceType = SERVICE_TYPES[ event.result[ "type" ] ];
      if ( type == null ) {
         var validTypes :Array = new Array();
         for ( var currentType :String in SERVICE_TYPES ) {
            validTypes.push( currentType );
         }
         dispatchEvent( new FaultEvent( FaultEvent.FAULT, this, null,
            "Unknown service type. Valid types are: " + validTypes.join( ", " ) ) );
         return;
      }

      var info :String = event.result[ "url" ];
      if ( ( info == null ) || ( info == "" ) ) {
         dispatchEvent( new FaultEvent( FaultEvent.FAULT, this, null,
            "Invalid config location: Empty url." ) );
         return;
      }

      var configLocation :ServiceLocation = new ServiceLocation( type, info );
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, configLocation ) );
   }

   private static var SERVICE_TYPES :Object = {
      xmlrpc: ServiceType.XML_RPC,
      xml: ServiceType.PLAIN_XML
   };
}
