import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Logger;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.business.ServiceLocator;
import at.klickverbot.theBlackboard.business.ServiceType;
import at.klickverbot.theBlackboard.vo.DirectConfiguration;

class at.klickverbot.theBlackboard.business.ConfigDelegate extends CoreObject {
   /**
    * Constructor.
    */
   public function ConfigDelegate( responder :IResponder ) {
      m_responder = responder;
   }

   public static function setConfigService( location :ServiceLocation ) :Boolean {
      return ServiceLocator.getInstance().initConfigService( location );
   }

   public function loadConfig() :Void {
      var operation :IOperation =
         ServiceLocator.getInstance().configService.getAll();

      operation.addEventListener( ResultEvent.RESULT, this, handleLoadResult );
      operation.addEventListener( FaultEvent.FAULT, this, handleFault );
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

      m_responder.onResult( new ResultEvent( ResultEvent.RESULT, this, config ) );
   }

   private function handleFault( event :FaultEvent ) :Void {
      m_responder.onFault( event );
   }

   private function checkSettingExists( source :Object, name :String ) :Boolean {
      if ( source[ name ] == null ) {
         failWithMessage( "Setting " + name + " not found in the recieved configuration." );
         return false;
      }
      return true;
   }

   private function failWithMessage( message :String ) :Void {
      m_responder.onFault( new FaultEvent( FaultEvent.FAULT, this, null, message ) );
   }

   private static var SERVICE_TYPES :Object = {
      xmlrpc: ServiceType.XML_RPC,
      local: ServiceType.LOCAL
   };

   private var m_responder :IResponder;
}
