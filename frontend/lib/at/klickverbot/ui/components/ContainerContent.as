import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.horizontalAlign.IHorizontalAlign;
import at.klickverbot.ui.layout.stretching.IStretchMode;
import at.klickverbot.ui.layout.verticalAlign.IVerticalAlign;

class at.klickverbot.ui.components.ContainerContent extends CoreObject {
   /**
    * Constructor.
    */
   public function ContainerContent( component :IUiComponent,
      stretchMode :IStretchMode, horizontalAlign :IHorizontalAlign,
      verticalAlign :IVerticalAlign ) {

      m_component = component;
      m_stretchMode = stretchMode;
      m_horizontalAlign = horizontalAlign;
      m_verticalAlign = verticalAlign;
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

   public function get horizontalAlign() :IHorizontalAlign {
      return m_horizontalAlign;
   }
   public function set horizontalAlign( to :IHorizontalAlign ) :Void {
      m_horizontalAlign = to;
   }

   public function get verticalAlign() :IVerticalAlign {
      return m_verticalAlign;
   }
   public function set verticalAlign( to :IVerticalAlign ) :Void {
      m_verticalAlign = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "component: " + m_component,
         "stretchMode: " + m_stretchMode,
         "horizontalAlign: " + m_horizontalAlign,
         "verticalAlign: " + m_verticalAlign
      ] );
   }

   private var m_component :IUiComponent;
   private var m_stretchMode :IStretchMode;
   private var m_horizontalAlign :IHorizontalAlign;
   private var m_verticalAlign :IVerticalAlign;
}
