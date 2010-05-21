import at.klickverbot.data.List;
import at.klickverbot.event.events.CollectionEvent;
import at.klickverbot.event.events.Event;
import at.klickverbot.theBlackboard.model.CaptchaRequest;
import at.klickverbot.theBlackboard.model.Configuration;
import at.klickverbot.theBlackboard.view.CaptchaForm;
import at.klickverbot.theBlackboard.view.ModalOverlayDisplay;
import at.klickverbot.theBlackboard.view.event.CaptchaAuthViewEvent;
import at.klickverbot.ui.components.CustomSizeableComponent;

class at.klickverbot.theBlackboard.view.CaptchaAuthView extends CustomSizeableComponent {
   public function CaptchaAuthView( requests :List, configuration :Configuration,
      overlayDisplay :ModalOverlayDisplay ) {

      m_requests = requests;
      m_configuration = configuration;
      m_overlayDisplay = overlayDisplay;

      m_requests.addEventListener( CollectionEvent.CHANGE, this, showForm );
   }

   private function showForm() :Void {
      var request :CaptchaRequest = CaptchaRequest( m_requests.getLast() );

      // TODO: Just hand off the URL?
      var form :CaptchaForm = new CaptchaForm( m_configuration, request );
      form.addEventListener( Event.COMPLETE, this, submitCaptcha );

      m_overlayDisplay.showOverlay( form );
   }

   private function submitCaptcha( event :Event ) :Void {
      var form :CaptchaForm = CaptchaForm( event.target );

      dispatchEvent( new CaptchaAuthViewEvent( CaptchaAuthViewEvent.SOLVE, this,
         form.getRequest(), form.getSolution() ) );

      m_overlayDisplay.hideOverlay( form );
   }

   private var m_requests :List;
   private var m_configuration :Configuration;
   private var m_overlayDisplay :ModalOverlayDisplay;
}
