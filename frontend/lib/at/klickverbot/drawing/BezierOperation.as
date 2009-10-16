import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.BezierSegment2D;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.graphics.Rect2D;

class at.klickverbot.drawing.BezierOperation extends CoreObject
   implements IDrawingOperation {

   /**
    * Constructor.
    */
   public function BezierOperation() {
      m_startPoint = null;
      m_segments = new Array();
      m_affectedArea = new Rect2D();
      m_style = new LineStyle();
   }

   public function getStartPoint() :Point2D {
      return m_startPoint.clone();
   }

   public function setStartPoint( point :Point2D ) :Void {
      m_affectedArea.extendToPoint( point );
      m_startPoint = point;
   }

   public function addSegment( segment :BezierSegment2D ) :Void {
      m_affectedArea.extendToPoint( segment.controlPoint );
      m_affectedArea.extendToPoint( segment.endPoint );
      m_segments.push( segment );
   }

   public function addSegments( segments :Array ) :Void {
      for ( var i :Number = 0; i < segments.length; ++i ) {
         addSegment( segments[ i ] );
      }
   }

   public function getSegments() :Array {
      return m_segments;
   }

   public function getAffectedArea() :Rect2D {
      var affectedWithLineWidth :Rect2D = m_affectedArea.clone();
      affectedWithLineWidth.extend( m_style.thickness );
      return affectedWithLineWidth;
   }


   public function getStyle() :LineStyle {
      return m_style;
   }

   public function setStyle( style :LineStyle ) :Void {
      m_style = style;
   }

   public function clear() :Void {
      m_startPoint = null;
      m_segments = new Array();
   }

   public function getNumPoints() :Number {
      // Start point + two points per segment.
      return ( ( m_startPoint == null ) ? 0 : 1 ) + m_segments.length * 2;
   }

   public function draw( target :MovieClip ) :Void {
      var numSegments :Number = m_segments.length;

      if ( m_startPoint == null ) {
         if ( numSegments > 0 ) {
            Debug.LIBRARY_LOG.warn( "Attempted to draw a BezierOperation " +
               "with segments but no start point: " + this );
         }
         return;
      }

      if ( numSegments == 0 ) {
         return;
      }

      m_style.setTargetStyle( target );

      target.moveTo( m_startPoint.x, m_startPoint.y );

      for ( var i :Number = 0; i < numSegments; ++i ) {
         var currentSegment :BezierSegment2D = BezierSegment2D( m_segments[ i ] );
         target.curveTo(
            currentSegment.controlPoint.x,
            currentSegment.controlPoint.y,
            currentSegment.endPoint.x,
            currentSegment.endPoint.y
         );
      }
   }

   /**
    * Creates a copy of this object.
    *
    * @param deep Speciefies if a shallow or a deep copy will be created.
    *        Defaults to true (deep).
    * @return The copied object.
    */
   public function clone( deep :Boolean ) :IDrawingOperation {
      if ( deep == null ) {
         deep = true;
      }

      var copy :BezierOperation = new BezierOperation();

      if ( deep ) {
         copy.m_style = m_style.clone();
         copy.m_affectedArea = m_affectedArea.clone();
         copy.m_startPoint = m_startPoint.clone();

         for ( var i :Number = 0; i < m_segments.length; ++i ) {
            copy.m_segments.push( BezierSegment2D( m_segments[ i ] ).clone( true ) );
         }
      } else {
         copy.m_style = m_style;
         copy.m_affectedArea = m_affectedArea;
         copy.m_startPoint = m_startPoint;

         for ( var i :Number = 0; i < m_segments.length; ++i ) {
            copy.m_segments.push( m_segments[ i ] );
         }
      }

      return copy;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_segments.length + " segment(s)" );
   }

   private var m_startPoint :Point2D;
   private var m_segments :Array;
   private var m_style :LineStyle;
   private var m_affectedArea :Rect2D;
}
