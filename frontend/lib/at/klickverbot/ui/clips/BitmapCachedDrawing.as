import at.klickverbot.core.CoreMovieClip;
import at.klickverbot.event.events.TimerEvent;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.util.Timer;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Class that extends MovieClip with caching for the standard vector drawing
 * functions and support for the at.klickverbot.drawing.* events.
 * Only the line drawing functions (moveTo, lineTo, curveTo, lineStyle) are
 * cached, calling the filling functions may lead to unexpected results.
 *
 * It can be either assigned to a library symbol or instantiated in a target
 * MovieClip using the create method.
 */
class at.klickverbot.ui.clips.BitmapCachedDrawing extends CoreMovieClip {
   /**
    * Constructor.
    * Private because it should only be called by <code>create()</code>.
    */
   private function BitmapCachedDrawing( target :MovieClip ) {
      super();

      // Create hack.
      target.__proto__ = this.__proto__;
      target.constructor = this.constructor;
      this = BitmapCachedDrawing( target );

      // Zero the min. and max. coordinates of the bufferClip because it has no
      // contents yet.
      m_bufferMinX = 0;
      m_bufferMaxX = 0;
      m_bufferMinY = 0;
      m_bufferMaxY = 0;

      // Turn the smoothing (when drawing to the bitmap) on per default.
      m_smoothing = true;

      m_bufferedCount = 0;
      m_bufferSize = 100;

      // Create the flushing timer but do not start it.
      m_flushInterval = 0;
      m_flushTimer = new Timer( m_flushInterval, 0 );
      m_flushTimer.addEventListener( TimerEvent.TIMER, this, flushTimer );

      // _height and _width always contain the size of the bounding box and
      // not the "real" not scaled size of the contents. Note that this value
      // is just a guess that can help to reduce the "expensive" resizing
      // operations if there is already some content in "this".
      var realWidth :Number = Math.ceil( 100 * this._width / this._xscale );
      var realHeight :Number = Math.ceil( 100 * this._height / this._yscale );

      // The bitmap can't be 0 px * 0 px because it cannot be created then. So
      // use some minimum values.
      realWidth = Math.max( realWidth, MIN_WIDTH );
      realHeight = Math.max( realHeight, MIN_HEIGHT );
      m_cachingBitmap = new BitmapData( realWidth, realHeight, true, 0 );


      var containerDepth :Number = this.getNextHighestDepth();
      m_bitmapContainer = this.createEmptyMovieClip(
         "bitmapContainer" + containerDepth, containerDepth );
      m_bitmapContainer.attachBitmap( m_cachingBitmap, CACHE_DEPTH, "auto", m_smoothing );

      m_tempClip = this.createEmptyMovieClip( "tempClip",
         this.getNextHighestDepth() );

      m_fixedSize = null;
   }

   /**
    * Creates an empty MovieClip linked to an instance of this class in the
    * target MovieClip using a hack by mojave found at flashforum.de.
    *
    * @param parent The MovieClip in which the instance is created.
    * @param instanceName An unique instance name for the the created instance.
    *        Pass null to use the default ("BitmapCachedDrawing" + depth).
    * @param depth The depth at which the instance is created. Pass null to use
    *        the default ( parent.getNextHighestDepth() ).
    * @return A reference to the newly created instance.
    */
   public static function create( parent :MovieClip, instanceName :String,
      depth :Number ) :BitmapCachedDrawing {

      if ( depth == undefined ) {
         depth = parent.getNextHighestDepth();
      }
      if ( instanceName == undefined ) {
         instanceName = "BitmapCachedDrawing" + depth;
      }

      var target :MovieClip = parent.createEmptyMovieClip( instanceName, depth );

      var classObj :BitmapCachedDrawing = new BitmapCachedDrawing( target );
      classObj = BitmapCachedDrawing( target );

      return classObj;
   }

   /**
    * Changes the line style.
    * Note that this function only supports the first three arguments of the
    * "original" flash function.
    *
    * @param thickness Thickness of the line in pt.
    * @param color Color of the line in standard web notation (8bit / channel).
    * @param alpha Alpha of the line from 0-100%.
    */
   public function lineStyle( thickness :Number, color :Number,
      alpha :Number ) :Void {

      m_currentThickness = thickness;
      m_currentColor = color;
      m_currentAlpha = alpha;

      m_tempClip.lineStyle( thickness, color, alpha );
   }

   /**
    * Draws a line from the current cursor position to the specified position.
    *
    * @param toX x-coordinate of the target.
    * @param toY y-coordinate of the target.
    */
   public function lineTo( toX :Number, toY :Number ) :Void {
      m_currentX = toX;
      m_currentY = toY;
      updateTempSize( toX, toY );

      m_tempClip.lineTo( toX, toY );
      cacheIfNecessaryWithNew();
   }

   /**
    * Draws a quadratic beziér curve from the current cursor position to the
    * specified anchor point using the specified control point.
    *
    * @param controlX x-coordinate of the control point.
    * @param controlY y-coordinate of the control point.
    * @param anchorX x-coordinate of the anchor point.
    * @param anchorY y-coordinate of the anchor point.
    */
   public function curveTo( controlX :Number, controlY :Number,
      anchorX :Number, anchorY :Number ) :Void {

      m_currentX = anchorX;
      m_currentY = anchorY;
      updateTempSize( controlX, controlY );
      updateTempSize( anchorX, anchorY );

      m_tempClip.curveTo( controlX, controlY, anchorX, anchorY );
      cacheIfNecessaryWithNew();
   }

   /**
    * Moves the drawing cursor from the current position to the specified
    * position.
    *
    * @param toX x-coordinate of the target.
    * @param toY y-coordinate of the target.
    */
   public function moveTo( toX :Number, toY :Number ) :Void {
      m_currentX = toX;
      m_currentY = toY;
      updateTempSize( toX, toY );

      m_tempClip.moveTo( toX, toY );
      cacheIfNecessaryWithNew();
   }

   /**
    * Clears the MovieClip from all the drawn lines.
    */
    public function clear() :Void {
       m_currentX = 0;
       m_currentY = 0;
       m_currentAlpha = 0;
       m_currentColor = 0;
       m_currentThickness = 0;

       cacheBuffer();
       var bufferRect :Rectangle = new Rectangle( 0, 0, m_cachingBitmap.width,
          m_cachingBitmap.height );
       m_cachingBitmap.fillRect( bufferRect, 0x0000000 );
       m_bitmapContainer.attachBitmap( m_cachingBitmap, CACHE_DEPTH, "auto", m_smoothing );
    }

   /**
    * Draws the recently drawn events (those which are in the temp clip)
    * immediately to the caching bitmap.
    */
   public function cacheBuffer() :Void {
      if ( m_bufferedCount == 0 ) {
         return;
      }

      expandCachingBitmap();

      // BitmapData.draw() always draws a MovieClip with its registration point
      // at [0,0] (bitmap coordinates). But we could have moved it in
      // expandCachingBitmap, so we need to apply a translation matrix to draw
      // it at the correct position.
      var translateMatrix :Matrix = new Matrix();
      translateMatrix.translate( -m_bitmapContainer._x, -m_bitmapContainer._y );

      m_cachingBitmap.draw( m_tempClip, translateMatrix );

      // TODO: Is it neccessary to attach it every time?
      m_bitmapContainer.attachBitmap( m_cachingBitmap, CACHE_DEPTH, "auto", m_smoothing );

      m_tempClip.clear();
      m_tempClip.lineStyle( m_currentThickness, m_currentColor,
         m_currentAlpha );
      m_tempClip.moveTo( m_currentX, m_currentY );

      // Zero the min. and max. coordinates of the bufferClip because it doesn't
      // have any contents now.
      m_bufferMinX = 0;
      m_bufferMaxX = 0;
      m_bufferMinY = 0;
      m_bufferMaxY = 0;

      m_bufferedCount = 0;
   }

   public function hitTestDrawn( testPoint :Point, threshold :Number ) :Boolean {
      if ( threshold == undefined ) {
         threshold = 255;
      }
      // Write any changes in the temp clip to the bitmap so we only need to do
      // the hit test once.
      cacheBuffer();

      var originPoint :Point = new Point( m_bitmapContainer._x,
         m_bitmapContainer._y );
      return m_cachingBitmap.hitTest( originPoint, threshold, testPoint );
   }

   public function removeMovieClip() :Void {
      m_flushTimer.stop();
      delete m_flushTimer;

      m_cachingBitmap.dispose();
      delete m_cachingBitmap;

      m_bitmapContainer.removeMovieClip();
      delete m_bitmapContainer;

      super.removeMovieClip();
   }

   /**
    * If a non-null fixed size value is set, drawed content is clipped to the
    * size specified as soon as it is drawn to the bitmap buffer.
    */
   public function get fixedSize() :Point2D {
      return m_fixedSize;
   }
   public function set fixedSize( to :Point2D ) :Void {
      if ( to && to != m_fixedSize ) {
         cacheBuffer();

         // Create a new caching bitmap with the appropriate size and copy over
         // the old cached contents which fit into it.
         var bufferRect :Rectangle = new Rectangle(
            -m_bitmapContainer._x, -m_bitmapContainer._y,
            -m_bitmapContainer._x + to.x, -m_bitmapContainer._y + to.y );
         var destPoint :Point = new Point( 0, 0 );

         var tempBitmap :BitmapData = new BitmapData( to.x, to.y,
            true, 0x00000000 );
         tempBitmap.copyPixels( m_cachingBitmap, bufferRect, destPoint );

         // Attach the new bitmap to the container (the old one gets removed
         // because it is at the same depth.
         m_bitmapContainer.attachBitmap( tempBitmap, CACHE_DEPTH, "auto", m_smoothing );

         // Try to free the resources used by the old caching bitmap. I am not
         // sure what is actually necessary.
         m_cachingBitmap.dispose();
         delete m_cachingBitmap;

         // From now on, use the new bitmap.
         m_cachingBitmap = tempBitmap;

         // Move the container to the origin, it might have been placed
         // elsewhere in expandCachingBitmap before.
         m_bitmapContainer._x = 0;
         m_bitmapContainer._y = 0;
      }

      m_fixedSize = to;
   }

   /**
    * If smoothing is activated when drawing to the caching bitmap.
    * When activated, you will get a slightly smoother result, but in some
    * cases it can look "dirty". Then it is better to disable smoothing.
    */
   public function get smoothing() :Boolean {
      return m_smoothing;
   }
   public function set smoothing( to :Boolean ) :Void {
      m_smoothing = to;
   }

   /**
    * After this amount of events is drawn to the temp clip, the events are
    * copied into the caching bitmap.
    */
   public function get bufferSize() :Number {
      return m_bufferSize;
   }
   public function set bufferSize( to :Number ) :Void {
      if ( 0 < to ) {
         m_bufferSize = to;
      }
   }

   /**
    * Every flushInterval milliseconds the buffer's contents (the temp clip)
    * are copied into the caching bitmap.
    */
   public function get flushInterval() :Number {
      return m_flushTimer.interval;
   }
   public function set flushInterval( to :Number ) :Void {
      // If zero, stop the timer,
      // if greater zero, set the timer to a new interval.
      if ( to == 0 ) {
         m_flushTimer.stop();
      } else if ( 0 < to ) {
         m_flushTimer.interval = to;
         m_flushTimer.start();
      }
   }


   /**
    * Increments the counter for the buffered operations (that ones that are
    * currently in the temp clip) and flushed the buffer if needed.
    */
   private function cacheIfNecessaryWithNew() :Void {
      ++m_bufferedCount;

      if ( m_bufferedCount > m_bufferSize ) {
         cacheBuffer();
      }
   }

   /**
    * Updates the stored minima and maxima of the buffered events' coordinates –
    * if needed.
    *
    * @param x the x-coordinate to check.
    * @param y the y-coordinate to check.
    */
   private function updateTempSize( x :Number, y :Number ) :Void {
      // Add resp. substract m_currentThickness to avoid lines being "cut off".
      if ( ( x - m_currentThickness ) < m_bufferMinX ) {
         m_bufferMinX = x - m_currentThickness;
      } else if ( m_bufferMaxX < ( x + m_currentThickness ) ) {
         m_bufferMaxX = x + m_currentThickness;
      }

      if ( ( y - m_currentThickness ) < m_bufferMinY ) {
         m_bufferMinY = y - m_currentThickness;
      } else if ( m_bufferMaxY < ( y + m_currentThickness ) ) {
         m_bufferMaxY = y + m_currentThickness;
      }
   }

   /**
    * Checks if the buffer clip exceeds the dimensions of the
    * the caching bitmap and resizes it if neccessary.
    */
   private function expandCachingBitmap() :Void {
      if ( m_fixedSize != null ) {
         return;
      }

      // Check if and where we need extra space in the bitmap for the
      // pending events.
      var leftXNeeded :Number = 0;
      var rightXNeeded :Number = 0;
      var topYNeeded :Number = 0;
      var bottomYNeeded :Number = 0;
      var needsResizing :Boolean = false;

      if ( m_bufferMinX < m_bitmapContainer._x ) {
         leftXNeeded = Math.ceil( m_bitmapContainer._x - m_bufferMinX );
         leftXNeeded += SAFETY_BORDER_SIZE;
         needsResizing = true;
      }
      if ( m_bufferMinY < m_bitmapContainer._y ) {
         topYNeeded = Math.ceil( m_bitmapContainer._y - m_bufferMinY );
         topYNeeded += SAFETY_BORDER_SIZE;
         needsResizing = true;
      }

      var rightEdgeX :Number = m_bitmapContainer._x + m_cachingBitmap.width;
      if ( rightEdgeX < m_bufferMaxX ) {
         rightXNeeded = Math.ceil( m_bufferMaxX - rightEdgeX );
         rightXNeeded += SAFETY_BORDER_SIZE;
         needsResizing = true;
      }

      var bottomEdgeY :Number = m_bitmapContainer._y + m_cachingBitmap.height;
      if ( bottomEdgeY < m_bufferMaxY ) {
         bottomYNeeded = Math.ceil( m_bufferMaxY - bottomEdgeY );
         bottomYNeeded += SAFETY_BORDER_SIZE;
         needsResizing = true;
      }

      // If we need extra space, copy the existing bitmap into a new,
      // bigger one.
      if ( needsResizing ) {
         var bufferRect :Rectangle = new Rectangle( 0, 0,
            m_cachingBitmap.width, m_cachingBitmap.height );

         var destPoint :Point = new Point( leftXNeeded, topYNeeded );

         var tempBitmap :BitmapData = new BitmapData(
            ( bufferRect.width + leftXNeeded + rightXNeeded ),
            ( bufferRect.height + topYNeeded + bottomYNeeded ),
            true, 0x00000000 );

         tempBitmap.copyPixels( m_cachingBitmap, bufferRect, destPoint );

         // Attach the new bitmap to the container (the old one gets removed
         // because it is at the same depth.
         m_bitmapContainer.attachBitmap( tempBitmap, CACHE_DEPTH, "auto", m_smoothing );

         // Try to free the resources used by the old caching bitmap. I am not
         // sure what is actually necessary.
         m_cachingBitmap.dispose();
         delete m_cachingBitmap;

         // From now on, use the new bitmap.
         m_cachingBitmap = tempBitmap;

         // Move the container -leftXNeeded on the x-axis and -topYNeeded on the
         // y-axis to bring the bitmap in the correct position. We have to keep
         // this in mind when we draw the temp clip to the bitmap in
         // cacheBuffer().
         m_bitmapContainer._x -= leftXNeeded;
         m_bitmapContainer._y -= topYNeeded;
      }
   }

   private function flushTimer( event :TimerEvent ) :Void {
      cacheBuffer();
   }


   private static var MIN_WIDTH :Number = 100;
   private static var MIN_HEIGHT :Number = 100;
   private static var CACHE_DEPTH :Number = 1;

   // The size of the safety border around the drawing content in the caching
   // bitmap in pixels.
   private static var SAFETY_BORDER_SIZE :Number = 10;

   private var m_tempClip :MovieClip;
   private var m_bitmapContainer :MovieClip;
   private var m_cachingBitmap :BitmapData;
   private var m_smoothing :Boolean;

   private var m_fixedSize :Point2D;

   private var m_currentThickness :Number;
   private var m_currentColor :Number;
   private var m_currentAlpha :Number;
   private var m_currentX :Number;
   private var m_currentY :Number;

   private var m_bufferMinX :Number;
   private var m_bufferMaxX :Number;
   private var m_bufferMinY :Number;
   private var m_bufferMaxY :Number;

   private var m_bufferedCount: Number;
   private var m_bufferSize :Number;
   private var m_flushInterval :Number;
   private var m_flushTimer :Timer;
}
