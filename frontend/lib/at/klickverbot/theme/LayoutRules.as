import at.klickverbot.core.CoreObject;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.layout.ContainerRule;

class at.klickverbot.theme.LayoutRules extends CoreObject {
   /**
    * Constructor.
    */
   public function LayoutRules() {
      m_containerRules = new Object();
   }

   public function addContainerRule( containerId :String, rule :ContainerRule ) :Void {
      m_containerRules[ containerId ] = rule;
   }

   public function getContainerRule( containerClipId :ClipId ) :ContainerRule {
      return m_containerRules[ containerClipId.getId() ];
   }

   private var m_containerRules :Object;
}
