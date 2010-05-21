import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.event.events.Event;
import at.klickverbot.theBlackboard.model.CaptchaRequest;
import at.klickverbot.theBlackboard.model.Configuration;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.RemoteImage;
import at.klickverbot.ui.components.Spacer;
import at.klickverbot.ui.components.themed.Button;
import at.klickverbot.ui.components.themed.MultiContainer;
import at.klickverbot.ui.components.themed.TextBox;

class at.klickverbot.theBlackboard.view.CaptchaForm
   extends CustomSizeableComponent {

   public function CaptchaForm( configuration :Configuration,
      request :CaptchaRequest ) {
      super();

      m_model = request;

      m_formContainer = new MultiContainer( AppClipId.CAPTCHA_AUTH_CONTAINER );

      m_image = new RemoteImage( configuration.captchaAuthImageUrl + "?id=" +
         request.id );
      m_formContainer.addContent( ContainerElement.CAPTCHA_IMAGE, m_image );

      m_inputText = new TextBox( AppClipId.DEFAULT_TEXT_BOX );
      m_formContainer.addContent(
         ContainerElement.CAPTCHA_INPUT, m_inputText );

      m_submitButton = new Button( AppClipId.NEXT_STEP_BUTTON );
      m_submitButton.oneShotMode = true;
      m_submitButton.addEventListener( ButtonEvent.PRESS, this, handleSubmitPress );
      m_formContainer.addContent(
         ContainerElement.CAPTCHA_SUBMIT, m_submitButton );
   }

   private function createUi() :Boolean {
      if ( !super.createUi() ) {
         return false;
      }

      if ( !m_formContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

      m_inputText.text = "";

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

   public function getRequest() :CaptchaRequest {
      return m_model;
   }

   public function getSolution() :String {
      return m_inputText.text;
   }

   private function handleSubmitPress( event :ButtonEvent ) :Void {
      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   private var m_model :CaptchaRequest;

   private var m_drawingAreaDummy :Spacer;

   private var m_formContainer :MultiContainer;
   private var m_image :RemoteImage;
   private var m_inputText :TextBox;
   private var m_submitButton :Button;
}
