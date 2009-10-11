import at.klickverbot.core.CoreObject;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.IOperationOptimizer;

/**
 * An OperationOptimizer stub for testing that doesn't do optimize anything.
 *
 */
class at.klickverbot.drawing.NullOptimizer extends CoreObject
   implements IOperationOptimizer {
   public function optimize( operation :IDrawingOperation ) :IDrawingOperation {
      return operation;
   }
}