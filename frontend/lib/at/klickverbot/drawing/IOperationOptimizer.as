import at.klickverbot.core.ICoreInterface;
import at.klickverbot.drawing.IDrawingOperation;

/**
 * Represents a class that optimizes a given IDrawingOperation.
 * The implementing classes can have various goals, for example smoothing
 * the lines or minimizing size and the number of operations.
 * An optimizer doesn't have to implement all types of IDrawingOperations, for
 * example there could be one that only optimizes LineOperations and leaves the
 * other ones untouched.
 *
 */

interface at.klickverbot.drawing.IOperationOptimizer extends ICoreInterface {
   /**
    * Optimizes the passed IDrawingOperation.
    *
    * @param operation An IDrawingOperation that will be optimized.
    * @return The optimized IDrawingOperation.
    */
   public function optimize( operation :IDrawingOperation ) :IDrawingOperation;
}