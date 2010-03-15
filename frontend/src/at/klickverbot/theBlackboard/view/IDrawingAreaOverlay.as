import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;

interface at.klickverbot.theBlackboard.view.IDrawingAreaOverlay extends IUiComponent {
   public function getDrawingAreaPosition() :Point2D;
   public function getDrawingAreaSize() :Point2D;
}
