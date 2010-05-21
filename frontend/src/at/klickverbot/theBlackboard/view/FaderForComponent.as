import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.Fader;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.theBlackboard.view.FaderForComponent extends CoreObject {
   /**
    * Constructor.
    */
   public function FaderForComponent( fader :Fader, component :IUiComponent ) {
      m_fader = fader;
      m_component = component;
   }

   public function get fader() :Fader {
      return m_fader;
   }
   public function set fader( to :Fader ) :Void {
      m_fader = to;
   }

   public function get component() :IUiComponent {
      return m_component;
   }
   public function set component( to :IUiComponent ) :Void {
      m_component = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "fader: " + m_fader,
         "component: " + m_component
      ] );
   }

   private var m_fader :Fader;
   private var m_component :IUiComponent;
}
