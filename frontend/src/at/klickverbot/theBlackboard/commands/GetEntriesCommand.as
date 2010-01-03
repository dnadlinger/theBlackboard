import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.ResponderCommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.business.EntryDelegate;
import at.klickverbot.theBlackboard.control.GetEntriesEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.vo.EntrySet;

class at.klickverbot.theBlackboard.commands.GetEntriesCommand extends ResponderCommand
   implements ICommand, IResponder {

   public function execute( event :CairngormEvent ) :Void {
      var entriesEvent :GetEntriesEvent = GetEntriesEvent( event );
      var currentSet :EntrySet = Model.getInstance().currentEntries;

      if ( ( !entriesEvent.forceRefresh ) &&
         ( entriesEvent.sortingType == currentSet.sortingType ) &&
         ( entriesEvent.startOffset == currentSet.startOffset ) &&
         ( entriesEvent.entryLimit == currentSet.entryLimit ) ) {
         // Nothing to do, we would just load the same entries again.
         complete();
         return;
      }

      var entriesDelegate :EntryDelegate = new EntryDelegate( this );
      entriesDelegate.getEntryRange( entriesEvent.sortingType,
         entriesEvent.startOffset, entriesEvent.entryLimit );
   }

   private function onDelegateResult( result :Object ) :Void {
      Model.getInstance().currentEntries = EntrySet( result );
      Logger.getLog( "GetEntriesCommand" ).info( "New EntrySet has been loaded." );
   }

   private function onDelegateFault( faultCode :Number, faultString :String ) :Void {
      Model.getInstance().serviceErrors.addItem(
         "Error while recieving entries from the server: " + faultString );
   }
}
