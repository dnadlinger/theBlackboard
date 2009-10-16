import at.klickverbot.core.ICoreInterface;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;

interface at.klickverbot.ui.components.stretching.IStretchMode extends ICoreInterface {
   public function fitToSize( component :IUiComponent, targetSize :Point2D ) :Void;
}
