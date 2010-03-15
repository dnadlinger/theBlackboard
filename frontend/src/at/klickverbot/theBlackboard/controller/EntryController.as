import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Logger;
import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.business.EntryDelegate;
import at.klickverbot.theBlackboard.view.EntryViewEvent;
import at.klickverbot.theBlackboard.vo.Entry;

class at.klickverbot.theBlackboard.controller.EntryController extends CoreObject {
   public function listenTo( target :IEventDispatcher ) :Void {
      target.addEventListener( EntryViewEvent.LOAD_ENTRY, this, loadEntry );
      target.addEventListener( EntryViewEvent.SAVE_ENTRY, this, saveEntry );
   }

   private function loadEntry( event :EntryViewEvent ) :Void {
      if ( ( event.entry.id == null ) || event.entry.loaded ) {
         // Nothing to do if the target entry is not stored on the server
         // or is already loaded.
         return;
      }

      // TODO: Find better way to keep track of the entry loaded.
      // (or create a controller per entry _model_, not view)
      m_model = event.entry;

      var delegate :EntryDelegate = new EntryDelegate();
      delegate.addEventListener( ResultEvent.RESULT, this, handleEntryResult );
      delegate.addEventListener( FaultEvent.FAULT, this, handleFault );
      delegate.getEntryById( event.entry.id );
   }

   private function saveEntry( event :EntryViewEvent ) :Void {
      if ( event.entry.id == null ) {
         var delegate :EntryDelegate = new EntryDelegate();
         delegate.addEventListener( FaultEvent.FAULT, this, handleFault );
         delegate.addEntry( event.entry );
      } else {
         Logger.getLog( "EntryController" ).error(
          "Saving edited entries not supported yet: " + event.entry );
      }
   }

   private function handleEntryResult( event :ResultEvent ) :Void {
      m_model.copyFrom( Entry( event.result ) );
   }

   private function handleFault( event :FaultEvent ) :Void {
      // XXX: Add to model.serviceErrors.
      Logger.getLog( "EntryController" ).error( "Service failed: " + event );
   }

   private var m_model :Entry;
}
