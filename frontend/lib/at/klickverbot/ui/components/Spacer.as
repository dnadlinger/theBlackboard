import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;

/**
 * Placeholder component that is completely empty.
 */
class at.klickverbot.ui.components.Spacer extends CustomSizeableComponent
   implements IUiComponent {

   /**
    * Constructor.
    */
   public function Spacer( size :Point2D ) {
      super();
      m_initialSize = size;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }
      m_sizeDummy._width = m_initialSize.x;
      m_sizeDummy._height = m_initialSize.y;
      return true;
   }

   private var m_initialSize :Point2D;
}
