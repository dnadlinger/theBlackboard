import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineOperation;
import at.klickverbot.graphics.Point2D;

/**
 * An IOperationOptimizer using the Lang line generalization alorithm.
 *
 * The implementation is based on
 * http://motiondraw.com/md/as_samples/t/LineGeneralization/demo.html,
 * http://www.sli.unimelb.edu.au/gisweb/LGmodule/LGSelect.htm has a nice
 * explanation of the algorithm itself.
 */
class at.klickverbot.drawing.LangReduceOptimizer extends CoreObject
   implements IOperationOptimizer {

   public function LangReduceOptimizer( lookAhead :Number, tolerance :Number ) {
      m_lookAhead = lookAhead;
      m_tolerance = tolerance;
   }

   public function optimize( operation :IDrawingOperation ) :IDrawingOperation {
      if ( !operation instanceof LineOperation ) {
         return operation.clone();
      }

      var source :LineOperation = LineOperation( operation );
      var points :Array = source.getPoints();
      var pointCount :Number = points.length;

      var result :LineOperation = new LineOperation();
      result.setStyle( source.getStyle() );
      result.addPoint( points[ 0 ] );

      // We cannot look further ahead than there are points.
      var lookAhead :Number = Math.min( m_lookAhead, pointCount- 1 );

      for ( var i :Number = 0; i < pointCount; ++i ){
         if ( lookAhead + i > pointCount ) {
            lookAhead = pointCount - i - 1;
         }

         var offset :Number = recursiveToleranceBar( points, i, lookAhead );
         if ( offset > 0 ) {
            result.addPoint( points[ i + offset ] );
            i += offset - 1;
         }
      }

      return result;
   }

   private function recursiveToleranceBar( points :Array, startIndex :Number,
      lookAhead :Number ) :Number {

      var start :Point2D = points[ startIndex ];
      var end :Point2D = points[ startIndex + lookAhead ];
      var v1 :Point2D = end.difference( start );

      for ( var i :Number = 1; i <= lookAhead; ++i ) {
         var current :Point2D = points[ startIndex + i ];
         var v2 :Point2D = current.difference( start );

         var angle :Number = Math.acos( v1.dot( v2 ) / ( v1.getLength() * v2.getLength() ) );
         if ( isNaN( angle ) ) {
            angle = 0;
         }

         if( Math.sin( angle ) * current.distanceTo( start ) >= m_tolerance ) {
            // The perpendicular offset to the previous points exceeds the
            // tolerance.
            if( lookAhead > 1 ){
               return recursiveToleranceBar( points, startIndex, lookAhead - 1 );
            } else {
               return 0;
            }
         }
      }

      return lookAhead;
   }

   public function get lookAhead() :Number {
      return m_lookAhead;
   }
   public function set lookAhead( to :Number ) :Void {
      Debug.assertLess( 1, to, "lookAhead must be larger than 1." );
      m_lookAhead = to;
   }

   public function get tolerance() :Number {
      return m_tolerance;
   }
   public function set tolerance( to :Number ) :Void {
      Debug.assertPositive( to, "tolerance must be positive." );
      m_tolerance = to;
   }

   private var m_lookAhead :Number;
   private var m_tolerance :Number;
}
