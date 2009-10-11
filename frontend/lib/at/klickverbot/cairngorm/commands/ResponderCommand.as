import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.cairngorm.commands.AbstractCommand;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;

class at.klickverbot.cairngorm.commands.ResponderCommand
   extends AbstractCommand implements IResponder, ICommand {

   public function onResult( data :ResultEvent ) :Void {
      onDelegateResult( data.result );
      complete();
   }

   public function onFault( info :FaultEvent ) :Void {
      onDelegateFault( info.faultCode, info.faultString );
      fail();
   }

   private function onDelegateResult( result :Object ) :Void {
      Debug.pureVirtualFunctionCall( "ResponderCommand.onDelegateResult" );
   }

   private function onDelegateFault( faultCode :Number, faultString :String ) :Void {
      Debug.pureVirtualFunctionCall( "ResponderCommand.onDelegateFault" );
   }
}
