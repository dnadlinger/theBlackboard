import at.klickverbot.ui.components.ContainerContent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.stretching.IStretchMode;

class at.klickverbot.ui.components.themed.MultiContainerContent extends ContainerContent {
   /**
    * Constructor.
    */
   public function MultiContainerContent( component :IUiComponent,
      stretchMode :IStretchMode, elementName :String ) {

      super( component, stretchMode );
      m_elementName = elementName;
   }

   public function get elementName() :String {
      return m_elementName;
   }
   public function set elementName( to :String ) :Void {
      m_elementName = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "elementName: " + m_elementName
      ] );
   }

   private var m_elementName :String;
}
