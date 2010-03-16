import at.klickverbot.debug.Logger;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceLocator;
import at.klickverbot.theBlackboard.service.ServiceType;
import at.klickverbot.theBlackboard.model.DirectConfiguration;

class at.klickverbot.theBlackboard.service.adapter.ConfigDelegate extends EventDispatcher {
   public static function setServiceLocation( location :ServiceLocation ) :Boolean {
      return ServiceLocator.getInstance().initConfigService( location );
   }

   public function loadConfig() :Void {
      var operation :IOperation =
         ServiceLocator.getInstance().configService.getAll();

      operation.addEventListener( ResultEvent.RESULT, this, handleLoadResult );
      operation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
      operation.execute();
   }

   private function handleLoadResult( event :ResultEvent ) :Void {
      var source :Object = event.result;
      var config :DirectConfiguration = new DirectConfiguration();

      if ( !checkSettingExists( source, "availableThemes" ) ) {
         return;
      }
      config.setAvailableThemes( Array( source[ "availableThemes" ] ) );


      if ( !checkSettingExists( source, "defaultTheme" ) ) {
         return;
      }
      config.setDefaultTheme( String( source[ "defaultTheme" ] ) );

      if ( !checkSettingExists( source, "drawingSize" ) ) {
         return;
      }
      var drawingSize :Number = Number( source[ "drawingSize" ] );
      if ( isNaN( drawingSize ) ) {
         failWithMessage( "Invalid (not a number) value set for drawing size." );
         return;
      }
      config.setDrawingSize( drawingSize );

      if ( !checkSettingExists( source, "entryPreloadLimit" ) ) {
         return;
      }
      var entryPreloadLimit :Number = Number( source[ "entryPreloadLimit" ] );
      if ( isNaN( entryPreloadLimit ) ) {
         Logger.getLog( "ConfigDelegate" ).warn(
            "Invalid (not a number) value set for drawing size." );
         return;
      }
      config.setEntryPreloadLimit( entryPreloadLimit );

      if ( !checkSettingExists( source, "entryServiceType" ) ) {
         return;
      }
      var serviceType :ServiceType = SERVICE_TYPES[ source[ "entryServiceType" ] ];
      if ( serviceType == null ) {
         var validTypes :Array = new Array();
         for ( var currentType :String in SERVICE_TYPES ) {
            validTypes.push( currentType );
         }
         failWithMessage( "Invalid entry service: Unknown service type. " +
            "Valid types are: " + validTypes.join( ", " ) );
      }

      if ( !checkSettingExists( source, "entryServiceInfo" ) ) {
         return;
      }
      var serviceInfo :Object = source[ "entryServiceInfo" ];
      config.setEntryServiceLocation( new ServiceLocation( serviceType, serviceInfo ) );

      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, config ) );
   }

   private function checkSettingExists( source :Object, name :String ) :Boolean {
      if ( source[ name ] == null ) {
         failWithMessage( "Setting " + name + " not found in the recieved configuration." );
         return false;
      }
      return true;
   }

   private function failWithMessage( message :String ) :Void {
      dispatchEvent( new FaultEvent( FaultEvent.FAULT, this, null, message ) );
   }

   private static var SERVICE_TYPES :Object = {
      xmlrpc: ServiceType.XML_RPC,
      local: ServiceType.LOCAL
   };
}
