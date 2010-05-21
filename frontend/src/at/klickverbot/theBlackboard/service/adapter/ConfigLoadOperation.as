import at.klickverbot.debug.Logger;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.model.DirectConfiguration;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.adapter.ServiceLocationParser;
import at.klickverbot.theBlackboard.service.backend.IConfigBackend;

class at.klickverbot.theBlackboard.service.adapter.ConfigLoadOperation
   extends AdapterOperation {

   /**
    * Constructor.
    */
   public function ConfigLoadOperation( backend :IConfigBackend, filters :Array ) {
      super( backend.getAll(), filters );
   }

   private function handleResult( event :ResultEvent ) :Void {
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

      var authLocation :ServiceLocation = getServiceLocation( source, "auth" );
      if ( authLocation == null ) {
         return;
      }
      config.setAuthServiceLocation( authLocation );

      var entryLocation :ServiceLocation = getServiceLocation( source, "entry" );
      if ( entryLocation == null ) {
         return;
      }
      config.setEntryServiceLocation( entryLocation );

      var captchaAuthLocation :ServiceLocation =
         getServiceLocation( source, "captchaAuth" );
      if ( captchaAuthLocation == null ) {
         return;
      }
      config.setCaptchaAuthServiceLocation( captchaAuthLocation );

      if ( !checkSettingExists( source, "captchaAuthImageUrl" ) ) {
         return;
      }
      config.setCaptchaAuthImageUrl( String( source[ "captchaAuthImageUrl" ] ) );

      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, config ) );
   }

   private function getServiceLocation( source :Object, name :String) :ServiceLocation {
      var locationParser :ServiceLocationParser = new ServiceLocationParser();

      if ( !checkSettingExists( source, name + "ServiceType" ) ) {
         return null;
      }
      if ( !checkSettingExists( source, name + "ServiceInfo" ) ) {
         return null;
      }

      return new ServiceLocation(
         locationParser.parseTypeString( source[ name + "ServiceType" ] ),
         source[ name + "ServiceInfo" ]
      );
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
}
