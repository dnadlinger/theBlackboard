import at.klickverbot.ui.layout.ScaleGridCell;
import at.klickverbot.ui.components.ContainerContent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.stretching.IStretchMode;

class at.klickverbot.ui.components.ScaleGridContainerContent extends ContainerContent {
   public function ScaleGridContainerContent( component :IUiComponent,
      stretchMode :IStretchMode, cell :ScaleGridCell ) {

      super( component, stretchMode );
      m_cell = cell;
   }

   public function get cell() :ScaleGridCell {
      return m_cell;
   }
   public function set cell( to :ScaleGridCell ) :Void {
      m_cell = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "cell: " + m_cell );
   }

   private var m_cell :ScaleGridCell;
}
