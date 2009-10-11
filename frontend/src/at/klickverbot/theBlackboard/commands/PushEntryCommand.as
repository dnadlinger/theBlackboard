import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.ResponderCommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.business.EntryDelegate;
import at.klickverbot.theBlackboard.control.SaveEntryEvent;
import at.klickverbot.theBlackboard.model.Model;

class at.klickverbot.theBlackboard.commands.PushEntryCommand extends ResponderCommand
   implements ICommand, IResponder {

   public function execute( event :CairngormEvent ) :Void {
      var pushEvent :SaveEntryEvent = SaveEntryEvent( event );

      var delegate :EntryDelegate = new EntryDelegate( this );
      delegate.addEntry( pushEvent.entry );
   }

   private function onDelegateResult( result :Object ) :Void {
      Logger.getLog( "PushEntryCommand" ).info( "The new entry has been saved." );
   }

   private function onDelegateFault( faultCode :Number, faultString :String ) :Void {
      Model.getInstance().serviceErrors.addItem(
         "Error while sending the entry to the server: " + faultString );
   }
}