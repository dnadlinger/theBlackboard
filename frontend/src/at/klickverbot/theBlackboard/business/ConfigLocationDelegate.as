import at.klickverbot.core.CoreObject;
import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.business.ServiceLocator;
import at.klickverbot.theBlackboard.business.ServiceType;

class at.klickverbot.theBlackboard.business.ConfigLocationDelegate extends CoreObject {

   /**
    * Constructor.
    */
   public function ConfigLocationDelegate( responder :IResponder ) {
      m_responder = responder;
   }

   public static function setConfigLocationService( location :ServiceLocation )
      :Boolean {
      return ServiceLocator.getInstance().initConfigLocationService( location );
   }

   public function loadConfigLocation() :Void {
      var operation :IOperation =
         ServiceLocator.getInstance().configLocationService.getConfigLocation();
      operation.addEventListener( ResultEvent.RESULT, this, handleLoadResult );
      operation.addEventListener( FaultEvent.FAULT, this, handleFault );
      operation.execute();
   }

   private function handleLoadResult( event :ResultEvent ) :Void {
      var type :ServiceType = SERVICE_TYPES[ event.result[ "type" ] ];
      if ( type == null ) {
         var validTypes :Array = new Array();
         for ( var currentType :String in SERVICE_TYPES ) {
            validTypes.push( currentType );
         }
         m_responder.onFault( new FaultEvent( FaultEvent.FAULT, this, null,
            "Unknown service type. Valid types are: " + validTypes.join( ", " ) ) );
         return;
      }

      var info :String = event.result[ "url" ];
      if ( ( info == null ) || ( info == "" ) ) {
         m_responder.onFault( new FaultEvent( FaultEvent.FAULT, this, null,
            "Invalid config location: Empty url." ) );
         return;
      }

      var configLocation :ServiceLocation = new ServiceLocation( type, info );
      m_responder.onResult( new ResultEvent( ResultEvent.RESULT, this, configLocation ) );
   }

   private function handleFault( event :FaultEvent ) :Void {
      m_responder.onFault( event );
   }

   private static var SERVICE_TYPES :Object = {
      xmlrpc: ServiceType.XML_RPC,
      xml: ServiceType.PLAIN_XML
   };

   private var m_responder :IResponder;
}
