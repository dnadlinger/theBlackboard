import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.ui.components.themed.MultiContainerContent extends CoreObject {
   /**
    * Constructor.
    */
   public function MultiContainerContent( component :IUiComponent,
      elementName :String ) {

      m_component = component;
      m_elementName = elementName;
   }

   public function get component() :IUiComponent {
      return m_component;
   }
   public function set component( to :IUiComponent ) :Void {
      m_component = to;
   }

   public function get elementName() :String {
      return m_elementName;
   }
   public function set elementName( to :String ) :Void {
      m_elementName = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "component: " + m_component,
         "elementName: " + m_elementName
      ] );
   }

   private var m_component :IUiComponent;
   private var m_elementName :String;
}
