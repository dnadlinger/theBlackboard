import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.theBlackboard.control.AddEntryEvent;
import at.klickverbot.theBlackboard.control.GetEntriesEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.model.ModelChangeEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.vo.EntrySet;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.HStrip;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.Spacer;
import at.klickverbot.ui.components.themed.Button;

class at.klickverbot.theBlackboard.view.NavigationView extends CustomSizeableComponent
   implements IUiComponent {

   public function NavigationView() {
      super();

      setupUi();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_iconStrip.create( m_container ) ) {
         super.destroy();
         return false;
      }

      Model.getInstance().addEventListener( ModelChangeEvent.CURRENT_ENTRIES,
         this, handleCurrentEntriesChange );
      updateNavigationButtonStates();

      updateSizeDummy();
      updateStripPosition();

      return true;
   }

   public function destroy() :Void {
      Model.getInstance().removeEventListener( ModelChangeEvent.CURRENT_ENTRIES,
         this, handleCurrentEntriesChange );

      m_iconStrip.destroy();

      super.destroy();
   }
   public function move( x: Number, y :Number ) :Void {
      super.move( x, y );
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attemped to resize a NavigationView that is not on stage." );
         return;
      }
      super.resize( width, height );
      updateStripPosition();
   }

   private function setupUi() :Void {
      m_iconStrip = new HStrip();

      m_previousPageButton = new Button( AppClipId.PREVIOUS_PAGE_BUTTON );
      m_previousPageButton.addEventListener( ButtonEvent.RELEASE,	this, previousPage );
      m_iconStrip.addContent( m_previousPageButton );

      m_nextPageButton = new Button( AppClipId.NEXT_PAGE_BUTTON );
      m_nextPageButton.addEventListener( ButtonEvent.RELEASE, this, nextPage );
      m_iconStrip.addContent( m_nextPageButton );

      // TODO: Get this from the theme config?
      m_iconStrip.addContent( new Spacer( new Point2D( 20, 20 ) ) );

      m_newEntryButton = new Button( AppClipId.NEW_ENTRY_BUTTON );
      m_newEntryButton.addEventListener( ButtonEvent.RELEASE, this, newEntry );
      m_iconStrip.addContent( m_newEntryButton );
   }

   private function updateStripPosition() :Void {
      var stripSize :Point2D = m_iconStrip.getSize();
      var xPosition :Number = m_sizeDummy._width / 2 - stripSize.x / 2;
      var yPosition :Number = m_sizeDummy._height / 2 - stripSize.y / 2;
      m_iconStrip.move( xPosition, yPosition );
   }

   private function updateNavigationButtonStates() :Void {
      var entrySet :EntrySet = Model.getInstance().currentEntries;
      if ( entrySet.startOffset > 0 ) {
         m_previousPageButton.setActive( true );
      } else {
         m_previousPageButton.setActive( false );
      }

      if ( entrySet.startOffset + entrySet.entryCount <
         Model.getInstance().entryCount ) {
         m_nextPageButton.setActive( true );
      } else {
         m_nextPageButton.setActive( false );
      }
   }

   private function previousPage() :Void {
      var currentSet :EntrySet = Model.getInstance().currentEntries;

      var startOffset :Number = currentSet.startOffset - currentSet.entryCount;
      if ( startOffset < 0 ) {
         startOffset = 0;
      }

      var entriesEvent :GetEntriesEvent = new GetEntriesEvent(
         currentSet.sortingType, startOffset, currentSet.entryCount, true );
      entriesEvent.dispatch();
   }

   private function nextPage() :Void {
      var currentSet :EntrySet = Model.getInstance().currentEntries;
      var startOffset :Number = currentSet.startOffset + currentSet.entryCount;

      // We don't need to care about how many entries exist, because if there are
      // less than we request, we'll get only as many back as exist.
      // FIXME: We have to take the grid capatity into account.
      var entriesEvent :GetEntriesEvent = new GetEntriesEvent(
         currentSet.sortingType, startOffset, currentSet.entryCount, true );
      entriesEvent.dispatch();
   }

   private function newEntry() :Void {
      var addEvent :AddEntryEvent = new AddEntryEvent();
      addEvent.dispatch();
   }

   private function handleCurrentEntriesChange() :Void {
      updateNavigationButtonStates();
   }

   private var m_iconStrip :HStrip;

   private var m_previousPageButton :Button;
   private var m_nextPageButton :Button;
   private var m_newEntryButton :Button;
}
