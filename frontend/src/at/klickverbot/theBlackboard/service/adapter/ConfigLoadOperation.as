import at.klickverbot.theBlackboard.service.adapter.ServiceLocationParser;
import at.klickverbot.debug.Logger;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.model.DirectConfiguration;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceType;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigBackend;

class at.klickverbot.theBlackboard.service.adapter.ConfigLoadOperation
   extends AdapterOperation {

   /**
    * Constructor.
    */
   public function ConfigLoadOperation( backend :IConfigBackend ) {
      super( backend.getAll() );
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

      if ( !checkSettingExists( source, "entryServiceType" ) ) {
         return;
      }
      if ( !checkSettingExists( source, "entryServiceInfo" ) ) {
         return;
      }
      var locationParser :ServiceLocationParser = new ServiceLocationParser();
      var serviceType :ServiceType =
         locationParser.parseTypeString( source[ "entryServiceType" ] );
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
}
