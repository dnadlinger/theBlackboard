import at.klickverbot.core.ICoreInterface;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.drawing.Rect2D;

/**
 * Represents an action that can be drawn to a MovieClip.
 *
 */
interface at.klickverbot.drawing.IDrawingOperation extends ICoreInterface {
   /**
    * Draws event to target MovieClip.
    * @param target The MovieClip to draw into.
    */
   public function draw( target :MovieClip ) :Void;

   public function getAffectedArea() :Rect2D;

   public function clone( deep :Boolean ) :IDrawingOperation;

   public function getNumPoints() :Number;

   public function getStyle() :LineStyle;
   public function setStyle( style :LineStyle ) :Void;
}