import at.klickverbot.core.ICoreInterface;
import at.klickverbot.graphics.Point2D;

interface at.klickverbot.theBlackboard.view.IDrawingOverlay
   extends ICoreInterface {

   public function getDrawingAreaPosition() :Point2D;

   public function getDrawingAreaSize() :Point2D;
}
