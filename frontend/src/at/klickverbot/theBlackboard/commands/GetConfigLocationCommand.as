import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.ResponderCommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.business.ConfigDelegate;
import at.klickverbot.theBlackboard.business.ConfigLocationDelegate;
import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.business.ServiceType;
import at.klickverbot.theBlackboard.model.Model;

class at.klickverbot.theBlackboard.commands.GetConfigLocationCommand
   extends ResponderCommand implements ICommand, IResponder {

   public function execute( event :CairngormEvent ) :Void {
      ConfigLocationDelegate.setConfigLocationService( DEFAULT_CONFIG_LOCATION_SERVICE );
      var delegate :ConfigLocationDelegate = new ConfigLocationDelegate( this );
      delegate.loadConfigLocation();
   }

   private function onDelegateResult( result :Object ) :Void {
      ConfigDelegate.setConfigService( ServiceLocation( result ) );
   }

   private function onDelegateFault( faultCode :Number, faultString :String ) :Void {
      Model.getInstance().serviceErrors.addItem(
         "Error while recieving config location: " + faultString + " (" + faultCode + ")" );
   }

   public static var DEFAULT_CONFIG_LOCATION_SERVICE :ServiceLocation =
      new ServiceLocation( ServiceType.PLAIN_XML, "configLocation.xml" );
}
