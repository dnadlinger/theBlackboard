import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.theBlackboard.view.TooltipLabel;
import at.klickverbot.theBlackboard.view.event.ViewSingleEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.HStrip;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.ui.components.themed.Button;
import at.klickverbot.ui.tooltip.TooltipManager;

/**
 * Toolbar displayed when viewing a single entry.
 *
 * Currently, this contains only a single button, but in future revisions, edit
 * mode will be accesible from here.
 */
class at.klickverbot.theBlackboard.view.ViewSingleToolbar extends McComponent {
   public function ViewSingleToolbar() {
      m_strip = new HStrip();

      m_backButton = new Button( AppClipId.BACK_TO_INDEX_BUTTON );
      TooltipManager.getInstance().setTooltip( m_backButton,
         new TooltipLabel( "Return to index page." ) );
      m_backButton.addEventListener( ButtonEvent.PRESS, this, handleBackPress );
      m_strip.addContent( m_backButton );
   }

   private function createUi() :Boolean {
      if ( !super.createUi() ) {
         return false;
      }

      return m_strip.create( m_container );
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_strip.destroy();
      }
      super.destroy();
   }

   private function handleBackPress( event :ButtonEvent ) :Void {
      disableButtons();
      dispatchEvent( new ViewSingleEvent( ViewSingleEvent.BACK, this ) );
   }

   private function disableButtons() :Void {
      // TODO: Add facility for grouping clickable UI components.
      m_backButton.setActive( false );
   }

   private var m_strip :HStrip;
   private var m_backButton :Button;
}
