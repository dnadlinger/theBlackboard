import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.theBlackboard.view.TooltipLabel;
import at.klickverbot.theBlackboard.view.event.NavigationViewEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.HStrip;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.ui.components.data.IPaginated;
import at.klickverbot.ui.components.data.PaginatedChangeEvent;
import at.klickverbot.ui.components.themed.Button;
import at.klickverbot.ui.tooltip.TooltipManager;

class at.klickverbot.theBlackboard.view.NavigationView extends McComponent {
   public function NavigationView( model :IPaginated ) {
      super();
      m_model = model;
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

      m_model.addEventListener( PaginatedChangeEvent.CURRENT_PAGE,
         this, updateNavigationButtonStates );
      m_model.addEventListener( PaginatedChangeEvent.PAGE_COUNT,
         this, updateNavigationButtonStates );
      updateNavigationButtonStates();

      return true;
   }

   public function destroy() :Void {
      m_model.removeEventListener( PaginatedChangeEvent.CURRENT_PAGE,
         this, updateNavigationButtonStates );
      m_model.removeEventListener( PaginatedChangeEvent.PAGE_COUNT,
         this, updateNavigationButtonStates );

      m_iconStrip.destroy();

      super.destroy();
   }

   private function setupUi() :Void {
      m_iconStrip = new HStrip();

      m_previousPageButton = new Button( AppClipId.PREVIOUS_PAGE_BUTTON );
      TooltipManager.getInstance().setTooltip( m_previousPageButton,
         new TooltipLabel( "Previous page" ) );
      m_previousPageButton.addEventListener( ButtonEvent.RELEASE,	this, previousPage );
      m_iconStrip.addContent( m_previousPageButton );

      m_nextPageButton = new Button( AppClipId.NEXT_PAGE_BUTTON );
      m_nextPageButton.addEventListener( ButtonEvent.RELEASE, this, nextPage );
      TooltipManager.getInstance().setTooltip( m_nextPageButton,
         new TooltipLabel( "Next page" ) );
      m_iconStrip.addContent( m_nextPageButton );

      m_newEntryButton = new Button( AppClipId.NEW_ENTRY_BUTTON );
      m_newEntryButton.addEventListener( ButtonEvent.RELEASE, this, newEntry );
      TooltipManager.getInstance().setTooltip( m_newEntryButton,
         new TooltipLabel( "Add new entry" ) );
      m_iconStrip.addContent( m_newEntryButton );
   }

   private function updateNavigationButtonStates() :Void {
      if ( m_model.getCurrentPage() > 0 ) {
         m_previousPageButton.setActive( true );
      } else {
         m_previousPageButton.setActive( false );
      }

      if ( m_model.getCurrentPage() < ( m_model.getPageCount() - 1 ) ) {
         m_nextPageButton.setActive( true );
      } else {
         m_nextPageButton.setActive( false );
      }
   }

   private function previousPage() :Void {
      dispatchEvent(
         new NavigationViewEvent( NavigationViewEvent.PREVIOUS_PAGE, this ) );
   }

   private function nextPage() :Void {
      dispatchEvent(
         new NavigationViewEvent( NavigationViewEvent.NEXT_PAGE, this ) );
   }

   private function newEntry() :Void {
      dispatchEvent(
         new NavigationViewEvent( NavigationViewEvent.NEW_ENTRY, this ) );
   }

   private var m_model :IPaginated;

   private var m_iconStrip :HStrip;
   private var m_previousPageButton :Button;
   private var m_nextPageButton :Button;
   private var m_newEntryButton :Button;
}
