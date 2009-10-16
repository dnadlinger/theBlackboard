import at.klickverbot.core.CoreObject;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.stretching.IStretchMode;

class at.klickverbot.ui.components.stretching.FillStretching extends CoreObject
   implements IStretchMode {

   public function fitToSize( component :IUiComponent, targetSize :Point2D ) :Void {
      component.setSize( targetSize );
   }
}
