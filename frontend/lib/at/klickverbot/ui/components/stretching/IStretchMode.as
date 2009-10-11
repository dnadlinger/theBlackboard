import at.klickverbot.drawing.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.core.ICoreInterface;

interface at.klickverbot.ui.components.stretching.IStretchMode extends ICoreInterface {
   public function fitToSize( component :IUiComponent, targetSize :Point2D ) :Void;
}
