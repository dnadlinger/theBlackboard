import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.layout.ScaleGridMapping;

class at.klickverbot.ui.layout.ContainerRule extends CoreObject {
   /**
    * Constructor.
    */
   public function ContainerRule() {
      m_scaleGrid = null;
   }

   public function hasScaleGrid() :Boolean {
      return ( m_scaleGrid != null );
   }

   public function getScaleGrid() :ScaleGridMapping {
      return m_scaleGrid;
   }

   public function setScaleGrid( scaleGrid :ScaleGridMapping ) :Void {
      m_scaleGrid = scaleGrid;
   }

   private var m_scaleGrid :ScaleGridMapping;
}