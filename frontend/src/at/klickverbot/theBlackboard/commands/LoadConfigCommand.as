import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.ResponderCommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.business.ConfigDelegate;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.vo.Configuration;

class at.klickverbot.theBlackboard.commands.LoadConfigCommand
   extends ResponderCommand implements ICommand, IResponder {

   public function execute( event :CairngormEvent ) :Void {
      var delegate :ConfigDelegate = new ConfigDelegate( this );
      delegate.loadConfig();
   }

   private function onDelegateResult( result :Object ) :Void {
      Logger.getLog( "LoadConfigCommand" ).info( "New configuration recieved." );
      Model.getInstance().config = Configuration( result );
   }

   private function onDelegateFault( faultCode :Number, faultString :String ) :Void {
      Model.getInstance().serviceErrors.addItem(
         "Error while recieving config: " + faultString + " (" + faultCode + ")" );
   }
}
