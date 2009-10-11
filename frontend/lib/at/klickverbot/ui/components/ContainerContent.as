import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.stretching.IStretchMode;

class at.klickverbot.ui.components.ContainerContent extends CoreObject {
   /**
    * Constructor.
    */
   public function ContainerContent( component :IUiComponent,
      stretchMode :IStretchMode ) {
      m_component = component;
      m_stretchMode = stretchMode;
   }

   public function get component() :IUiComponent {
      return m_component;
   }
   public function set component( to :IUiComponent ) :Void {
      m_component = to;
   }

   public function get stretchMode() :IStretchMode {
      return m_stretchMode;
   }
   public function set stretchMode( to :IStretchMode ) :Void {
      m_stretchMode = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "component: " + m_component,
         "stretchMode: " + m_stretchMode
      ] );
   }

   private var m_component :IUiComponent;
   private var m_stretchMode :IStretchMode;
}
