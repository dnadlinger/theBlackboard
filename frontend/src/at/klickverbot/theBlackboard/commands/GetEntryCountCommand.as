import at.klickverbot.cairngorm.commands.ResponderCommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.business.EntryDelegate;
import at.klickverbot.theBlackboard.model.Model;

class at.klickverbot.theBlackboard.commands.GetEntryCountCommand
   extends ResponderCommand {

   public function execute( event :CairngormEvent ) :Void {
      var entriesDelegate :EntryDelegate = new EntryDelegate( this );
      entriesDelegate.getEntryCount();
   }

   private function onDelegateResult( result :Object ) :Void {
      Model.getInstance().entryCount = Number( result );
      Logger.getLog( "GetEntriesCommand" ).info( result + " entries available." );
   }

   private function onDelegateFault( faultCode :Number, faultString :String ) :Void {
      Model.getInstance().serviceErrors.addItem(
         "Error while retrieving the entry count from the server: " + faultString );
   }
}
