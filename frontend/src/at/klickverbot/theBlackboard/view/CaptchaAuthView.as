import at.klickverbot.data.List;
import at.klickverbot.debug.Logger;
import at.klickverbot.event.events.CollectionEvent;
import at.klickverbot.theBlackboard.model.Configuration;
import at.klickverbot.ui.components.CustomSizeableComponent;

class at.klickverbot.theBlackboard.view.CaptchaAuthView extends CustomSizeableComponent {
   public function CaptchaAuthView( requests :List, configuration :Configuration ) {
      m_requests = requests;
      m_configuration = configuration;

      m_requests.addEventListener( CollectionEvent.CHANGE,
         this, handleNewRequest );
   }

   private function handleNewRequest( event :CollectionEvent ) :Void {
      Logger.getLog( "CaptchaAuthView" ).info( "New captcha auth request: " +
         m_requests.getLast() );
   }

   private var m_requests :List;
   private var m_configuration :Configuration;
}
