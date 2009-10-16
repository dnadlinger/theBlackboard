import at.klickverbot.core.CoreObject;
import at.klickverbot.drawing.BezierOperation;
import at.klickverbot.drawing.BezierSegment2D;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineOperation;
import at.klickverbot.graphics.Point2D;

/**
 * An OperationOptimizer that makes a smooth BezierOperation out of a
 * LineOperation and does nothing for other types of operations.
 *
 * Loosly based on an example from hgseib:
 * http://www.seibsprogrammladen.de/frame1.html?Prgm/Beispiele/flash6
 *
 * TODO: Adapt better algorithm from http://motiondraw.com/md/as_samples/t/LineGeneralization/demo.html
 *
 */
class at.klickverbot.drawing.BezierSmoother extends CoreObject
   implements IOperationOptimizer {

   public function optimize( operation :IDrawingOperation ) :IDrawingOperation {
      if ( operation instanceof LineOperation ) {
         var lineOp :LineOperation = LineOperation( operation );

         // We need at least three points – the starting point and a segment.
         if ( lineOp.getNumPoints() < 3 ) {
            return lineOp.clone();
         }

         var points :Array = lineOp.getPoints();

         var newOp :BezierOperation = new BezierOperation();
         newOp.setStyle( lineOp.getStyle() );

         newOp.setStartPoint( points[ 0 ] );

         var tempSegment :BezierSegment2D;
         var halfPoint :Point2D;

         // We have to process the last two points (the last segment) manually.
         var numPoints :Number = points.length - 2;

         // We don't process the start point, so start with index 1.
         for ( var i :Number = 2; i < numPoints; ++i ) {
            // Compute the point excatly in the middle on the line between this
            // point and the next point.
            halfPoint = points[ i ].clone();

            halfPoint.add( points[ i + 1 ] );
            halfPoint.scale( 0.5 );

            tempSegment = new BezierSegment2D( points[ i ],	halfPoint );
            newOp.addSegment( tempSegment );
         }

         // Process the last two points manually (because we need the last
         // point to be exactly the end point).
         tempSegment = new BezierSegment2D( points[ numPoints ], points[ numPoints + 1 ] );
         newOp.addSegment( tempSegment );

         return newOp;
      } else {
         // If the operation is no LineOperation, we just return an
         // unmodified copy.
         return operation.clone();
      }
   }
}