import at.klickverbot.core.CoreObject;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.stretching.IStretchMode;

class at.klickverbot.ui.layout.stretching.NoStretching extends CoreObject
   implements IStretchMode {

   public function fitToSize( component :IUiComponent, targetSize :Point2D ) :Void {
      // Do nothing.
   }
}
