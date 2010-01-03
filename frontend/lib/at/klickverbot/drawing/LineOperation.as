import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.graphics.Rect2D;

class at.klickverbot.drawing.LineOperation extends CoreObject
   implements IDrawingOperation {
   /**
    * Constructor.
    */
   public function LineOperation() {
      m_points = new Array();
      m_affectedArea = new Rect2D();
      m_style = new LineStyle();
   }

   public function addPoint( point :Point2D ) :Void {
      m_affectedArea.extendToPoint( point );
      m_points.push( point );
   }

   public function addPoints( points :Array ) :Void {
      m_points.concat( points );
      for ( var i :Number = 0; i < points.length; ++i ) {
         m_affectedArea.extendToPoint( points[ i ] );
      }
   }

   public function getPoints() :Array {
      return m_points.slice();
   }

   public function getNumPoints() :Number {
      return m_points.length;
   }
   public function getAffectedArea() :Rect2D {
      var affectedWithLineWidth :Rect2D = m_affectedArea.clone();
      affectedWithLineWidth.extend( m_style.thickness );
      return affectedWithLineWidth;
   }
   public function getStyle() :LineStyle {
      return m_style.clone();
   }

   public function setStyle( style :LineStyle ) :Void {
      m_style = style;
   }

   public function clear() :Void {
      m_points = new Array();
   }

   /**
    * Draws the line to the target MovieClip.
    * If there is no point in the list, this function does nothing. If there is
    * one point in the list, this function sets the line style to the defined
    * style and moves the drawing cursor to the only point.
    *
    * @param target The MovieClip to draw into.
    */
   public function draw( target :MovieClip ) :Void {
      var numPoints :Number = m_points.length;

      if ( numPoints == 0 ) {
         return;
      } else {
         m_style.setTargetStyle( target );
         target.moveTo( m_points[ 0 ].x, m_points[ 0 ].y );

         for ( var i :Number = 1; i < numPoints; ++i ) {
            target.moveTo( m_points[ i-1 ].x, m_points[ i-1 ].y );
            target.lineTo( m_points[ i ].x, m_points[ i ].y );
         }
      }
   }

   /**
    * Draws only a part of the line to the target MovieClip.
    *
    * The first point that is drawn specifies the starting point (where to move
    * the drawing cursor), so e. g. use the following for drawing the last
    * segment: drawPart( -2, null, target );
    *
    * @param start The index of the point where to start drawing
    *        (starting with zero). If negative, the starting point is specified
    *        from the last point on backwards, -1 being the last point. Defaults
    *        to the first point.
    * @param end The index of the point where to end drawing
    *        (starting with zero). If negative, the end point is specified
    *        from the last point on backwards, -1 being the last point. Defaults
    *        to the last point.
    */
   public function drawPart( start :Number, end :Number, target :MovieClip ) :Void {
      if ( start == null ) {
         start = 0;
      } else if ( start < 0 ) {
         start = m_points.length + start;
      }
      if ( end == null ) {
         end = m_points.length - 1;
      } else if ( end < 0 ) {
         end = m_points.length + end;
      }

      Debug.assertInRange( 0, start, m_points.length - 1,
         "Not a valid start index:" + start );
      Debug.assertInRange( 0, end, m_points.length - 1,
         "Not a valid end index:" + end );

      // Nothing to draw.
      if ( end <= start ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Nothing to draw because end <= start." );
         return;
      }

      m_style.setTargetStyle( target );
      target.moveTo( m_points[ start ].x, m_points[ start ].y );

      for ( var i :Number = start + 1; i <= end; ++i ) {
         target.lineTo( m_points[ i ].x, m_points[ i ].y );
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

      var copy :LineOperation = new LineOperation();

      if ( deep ) {
         copy.m_style = m_style.clone();
         copy.m_affectedArea = m_affectedArea.clone( true );

         for ( var i :Number = 0; i < m_points.length; ++i ) {
            copy.m_points.push( Point2D( m_points[ i ] ).clone() );
         }
      } else {
         copy.m_style = m_style;
         copy.m_affectedArea = m_affectedArea;

         for ( var i :Number = 0; i < m_points.length; ++i ) {
            copy.m_points.push( m_points[ i ] );
         }
      }

      return copy;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_points.length + " points" );
   }

   private var m_points :Array;
   private var m_style :LineStyle;

   private var m_affectedArea :Rect2D;
}
