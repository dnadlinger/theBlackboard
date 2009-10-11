import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineOperation;
import at.klickverbot.drawing.Point2D;

/**
 * A simple OperationOptimizer that reduces unneeded points.
 *
 * Loosly based on an example from hgseib:
 * http://www.seibsprogrammladen.de/frame1.html?Prgm/Beispiele/flash6
 *
 * TODO: Adapt http://motiondraw.com/md/as_samples/t/LineGeneralization/demo.html
 *
 */
class at.klickverbot.drawing.ReducePointsOptimizer extends CoreObject
   implements IOperationOptimizer {

   /**
    * Constructor.
    */
   public function ReducePointsOptimizer( minDistance :Number,
      straighten :Number ) {

      if ( minDistance == null ) {
         minDistance = DEFAULT_MIN_DISTANCE;
      }

      if ( straighten == null ) {
         straighten = DEFAULT_STRAIGHTEN;
      }

      // Using accessors to get validity cheks.
      this.minDistance = minDistance;
      this.straighten = straighten;
   }

   public function optimize( operation :IDrawingOperation ) :IDrawingOperation {
      if ( operation instanceof LineOperation ) {
         var lineOp :LineOperation = LineOperation( operation );
         var numPoints :Number = lineOp.getNumPoints();

         // We need at least four points for this to work
         if ( numPoints <= 4 ) {
            return lineOp.clone();
         }

         var oldPoints :Array = lineOp.getPoints();

         var newOp :LineOperation = new LineOperation();
         newOp.setStyle( lineOp.getStyle() );

         // Add the first point manually.
         newOp.addPoint( oldPoints[ 0 ] );

         // START: Unoptimized script from hgseib.
         var i :Number = 2;
         var j :Number = 1;
         var k :Number = 0;

         var length :Number;
         var iPoint :Point2D;
         var jPoint :Point2D;
         var kPoint :Point2D;

         while ( ++i < numPoints ) {
            iPoint = Point2D( oldPoints[ i ] );
            jPoint = Point2D( oldPoints[ j ] );
            kPoint = Point2D( oldPoints[ k ] );

            length = kPoint.distanceTo( jPoint );
            if ( length > m_minDistance ) {
               if ( ( kPoint.distanceTo( iPoint ) /
                  ( length + jPoint.distanceTo( iPoint ) ) ) <	m_straightenCoeff ) {

                  newOp.addPoint( oldPoints[ i - 1 ] );
                  k = j;
               }
            }
            ++j;
         }
         // END: Unoptimized script from hgseib.

         // Add the last point manually.
         newOp.addPoint( oldPoints[ numPoints - 1 ] );

         return newOp;

      } else {
         return operation.clone();
      }
   }

   public function get minDistance() :Number {
      return m_minDistance;
   }
   public function set minDistance( to :Number ) :Void {
      Debug.assertPositive( to, "Minimum distance must be positive!" );
      m_minDistance = to;
   }

   public function get straighten() :Number {
      return m_straightenCoeff;
   }
   public function set straighten( to :Number ) :Void {
      Debug.assertPositive( to, "Straighten level must be positive!" );
      m_straightenCoeff = 1 - ( to * 0.001 );
   }

   private static var DEFAULT_MIN_DISTANCE :Number = 3;
   private static var DEFAULT_STRAIGHTEN :Number = 2;

   private var m_minDistance :Number;
   private var m_straightenCoeff :Number;
}