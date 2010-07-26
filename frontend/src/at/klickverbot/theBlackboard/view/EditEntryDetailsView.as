import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.event.events.Event;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Spacer;
import at.klickverbot.ui.components.themed.Button;
import at.klickverbot.ui.components.themed.MultiContainer;
import at.klickverbot.ui.components.themed.TextBox;

class at.klickverbot.theBlackboard.view.EditEntryDetailsView
   extends CustomSizeableComponent {

   public function EditEntryDetailsView( model :Entry ) {
      super();

      m_model = model;

      m_formContainer = new MultiContainer( AppClipId.ENTRY_DETAILS_CONTAINER );

      m_authorText = new TextBox( AppClipId.DEFAULT_TEXT_BOX );
      m_formContainer.addContent(
         ContainerElement.DETAILS_FORM_AUTHOR, m_authorText );

      m_captionText = new TextBox( AppClipId.DEFAULT_TEXT_BOX );
      m_formContainer.addContent(
         ContainerElement.DETAILS_FORM_CAPTION, m_captionText );

      m_submitButton = new Button( AppClipId.SUBMIT_BUTTON );
      m_submitButton.oneShotMode = true;
      m_submitButton.addEventListener( ButtonEvent.PRESS, this, handleSubmitPress );
      m_formContainer.addContent(
         ContainerElement.DETAILS_FORM_SUBMIT, m_submitButton );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_formContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

      m_authorText.text = ( m_model.author == null ) ? "" : m_model.author;
      m_captionText.text = ( m_model.author == null ) ? "" : m_model.author;

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_formContainer.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_formContainer.resize( width, height );
   }

   private function handleSubmitPress( event :ButtonEvent ) :Void {
      // TODO: Validity checks here.
      m_model.author = m_authorText.text;
      m_model.caption = m_captionText.text;

      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   private var m_model :Entry;

   private var m_drawingAreaDummy :Spacer;

   private var m_formContainer :MultiContainer;
   private var m_authorText :TextBox;
   private var m_captionText :TextBox;
   private var m_submitButton :Button;
}
