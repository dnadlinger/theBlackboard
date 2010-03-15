import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.business.ServiceLocator;
import at.klickverbot.theBlackboard.business.ServiceType;

class at.klickverbot.theBlackboard.business.ConfigLocationDelegate
   extends EventDispatcher {

   public static function setServiceLocation( location :ServiceLocation )
      :Boolean {
      return ServiceLocator.getInstance().initConfigLocationService( location );
   }

   public function loadConfigLocation() :Void {
      var operation :IOperation =
         ServiceLocator.getInstance().configLocationService.getConfigLocation();
      operation.addEventListener( ResultEvent.RESULT, this, handleLoadResult );
      operation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
      operation.execute();
   }

   private function handleLoadResult( event :ResultEvent ) :Void {
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
