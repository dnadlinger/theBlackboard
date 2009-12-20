import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.ScaleGridCell;

class at.klickverbot.ui.components.ScaleGridContent extends CoreObject {
   public function ScaleGridContent( cell :ScaleGridCell,
      component :IUiComponent ) {

      m_cell = cell;
      m_component = component;
   }

   public function get cell() :ScaleGridCell {
      return m_cell;
   }
   public function set cell( to :ScaleGridCell ) :Void {
      m_cell = to;
   }

   public function get component() :IUiComponent {
      return m_component;
   }
   public function set component( to :IUiComponent ) :Void {
      m_component = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "cell: " + m_cell,
         "container: " + m_component
      ] );
   }

   private var m_cell :ScaleGridCell;
   private var m_component :IUiComponent;
}
