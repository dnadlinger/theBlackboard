import at.klickverbot.theBlackboard.view.TooltipLabel;
import at.klickverbot.ui.tooltip.TooltipManager;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.theBlackboard.view.event.SubmitDiscardEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.HStrip;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.ui.components.themed.Button;

class at.klickverbot.theBlackboard.view.SubmitDiscardView extends McComponent {
   /**
    * Constructor.
    */
   public function SubmitDiscardView() {
      m_strip = new HStrip();

      m_discardButton = new Button( AppClipId.DISCARD_BUTTON );
      TooltipManager.getInstance().setTooltip( m_discardButton,
         new TooltipLabel( "Discard the draft and return to the main view." ) );
      m_discardButton.addEventListener( ButtonEvent.PRESS, this, handleDiscardPress );
      m_strip.addContent( m_discardButton );

      m_submitButton = new Button( AppClipId.SUBMIT_BUTTON );
      TooltipManager.getInstance().setTooltip( m_submitButton,
         new TooltipLabel( "Submit the drawing." ) );
      m_submitButton.addEventListener( ButtonEvent.PRESS, this, handleSubmitPress );
      m_strip.addContent( m_submitButton );
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

   private function handleSubmitPress( event :ButtonEvent ) :Void {
      disableButtons();
      dispatchEvent( new SubmitDiscardEvent( SubmitDiscardEvent.SUBMIT, this ) );
   }

   private function handleDiscardPress( event :ButtonEvent ) :Void {
      disableButtons();
      dispatchEvent( new SubmitDiscardEvent( SubmitDiscardEvent.DISCARD, this ) );
   }

   private function disableButtons() :Void {
      // TODO: Add facility for grouping clickable UI components.
      // This could be used for the radio buttons in DrawingToolbox and the
      // button handling here.
      m_discardButton.setActive( false );
      m_submitButton.setActive( false );
   }

   private var m_strip :HStrip;
   private var m_discardButton :Button;
   private var m_submitButton :Button;
}
