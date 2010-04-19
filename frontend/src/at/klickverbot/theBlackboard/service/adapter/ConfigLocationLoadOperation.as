import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceType;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.adapter.ServiceLocationParser;
import at.klickverbot.theBlackboard.service.backend.IConfigLocationBackend;

class at.klickverbot.theBlackboard.service.adapter.ConfigLocationLoadOperation
   extends AdapterOperation {

   /**
    * Constructor.
    */
   public function ConfigLocationLoadOperation(
      backend :IConfigLocationBackend, filters :Array ) {

      super( backend.getConfigLocation(), filters );
   }

   private function handleResult( event :ResultEvent ) :Void {
      var locationParser :ServiceLocationParser = new ServiceLocationParser();
      var type :ServiceType =
         locationParser.parseTypeString( event.result[ "type" ] );

      var info :String = event.result[ "url" ];
      if ( ( info == null ) || ( info == "" ) ) {
         dispatchEvent( new FaultEvent( FaultEvent.FAULT, this, null,
            "Invalid config location: Empty url." ) );
         return;
      }

      var configLocation :ServiceLocation = new ServiceLocation( type, info );
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, configLocation ) );
   }
}
