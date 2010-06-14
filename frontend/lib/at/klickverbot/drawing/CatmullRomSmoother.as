import at.klickverbot.core.CoreObject;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineOperation;
import at.klickverbot.graphics.Point2D;

/**
 * An IOperationOptimizer which smoothes a given LineOperation using Catmull-Rom
 * splines.
 *
 * The implementation has been adapted from an example by Andreas Weber:
 * http://motiondraw.com/md/as_samples/t/LineGeneralization/demo.html.
 */
class at.klickverbot.drawing.CatmullRomSmoother extends CoreObject
   implements IOperationOptimizer {

   public function CatmullRomSmoother( approxLineLength :Number ) {
      m_approxLineLength = approxLineLength;
   }

   public function optimize( operation :IDrawingOperation ) :IDrawingOperation {
      if ( !( operation instanceof LineOperation ) ) {
         return operation.clone();
      }

      var source :LineOperation = LineOperation( operation );

      var result :LineOperation = new LineOperation();
      result.setStyle( source.getStyle() );

      var points :Array = source.getPoints();
      points.unshift( points[ 0 ] );
      points.push( points[ points.length - 1 ] );

      var lastIndex :Number = points.length - 3;
      for ( var i :Number = 0; i < lastIndex; ++i ) {
         var p1 :Point2D = points[ i + 1 ];
         var p2 :Point2D = points[ i + 2 ];
         var pMid :Point2D =
            catmullRom( 0.5, points[ i ], p1, p2, points[ i + 3 ] );

         var dist :Number = pMid.distanceTo( p1 ) + pMid.distanceTo( p2 );
         var t :Number = m_approxLineLength / dist;

         var s :Number = 0;
         while ( s < 1 ) {
            result.addPoint(
               catmullRom( s, points[ i ], p1, p2, points[ i + 3 ] ) );
            s += t;
         }
      }
      result.addPoint( catmullRom( 1, points[ lastIndex - 1 ],points[ lastIndex ],
         points[ lastIndex + 1 ], points[ lastIndex + 2 ] ) );

      return result;
   }

   private function catmullRom( t:Number,
      p0 :Point2D, p1 :Point2D, p2 :Point2D, p3 :Point2D ) :Point2D {

      var t2 :Number = t * t;
      var t3 :Number = t * t2;
      return new Point2D(
         0.5 * (
            ( 2 * p1.x ) + ( -p0.x + p2.x ) * t +
            ( 2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x ) * t2 +
            ( -p0.x + 3 * p1.x - 3 * p2.x + p3.x ) * t3
         ), 0.5 * (
            ( 2 * p1.y ) + ( -p0.y + p2.y ) * t +
            ( 2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y ) * t2 +
            ( -p0.y + 3 * p1.y- 3 * p2.y + p3.y ) * t3
         )
      );
   }

   private var m_approxLineLength :Number;
}
