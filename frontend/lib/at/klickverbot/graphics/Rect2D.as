import at.klickverbot.core.CoreObject;
import at.klickverbot.graphics.Point2D;

/**
 * A rectangle (in 2D space).
 *
 * Uses the defualt screen coordinates, not the mathematical ones:
 * +x => right, +y => bottom.
 */
class at.klickverbot.graphics.Rect2D extends CoreObject {
   /**
    * Constructor.
    * Doesn't provide direct specification of the anchor points because the
    * validity checks are a bit tricky.
    */
   public function Rect2D() {
      m_topLeft = new Point2D( 0, 0 );
      m_bottomRight = new Point2D( 0, 0 );
   }

   /**
    * Sets the two "key-corners" of the rectangle, the upper left and the
    * bottom right corner.
    * Note that the corners are set as a copy of the supplied points, you cannot
    * change them directly using the same reference afterwards.
    *
    * @param topLeft The upper left corner.
    * @param bottomRight The bottom right corner.
    */
   public function setPoints( topLeft :Point2D, bottomRight :Point2D )
      :Boolean {
      if ( bottomRight.x < topLeft.x ) {
         return false;
      }
      if ( bottomRight.y < topLeft.y ) {
         return false;
      }

      m_topLeft = topLeft.clone();
      m_bottomRight = bottomRight.clone();
   }

   /**
    * Returns the upper left corner.
    */
   public function getTopLeft() :Point2D {
      return m_topLeft.clone();
   }

   /**
    * Sets the upper left corner of the rectangle to the specified point.
    * If it is no longer the upper left corner, the points are automatically
    * corrected.
    *
    * Note that the corner is set as a copy of the supplied point, you cannot
    * change it directly using the same reference afterwards.
    */
   public function setTopLeft( to :Point2D ) :Void {
      /*if ( to.x <= m_bottomRight.x ) {
         if ( to.y <= m_bottomRight.y ) {
            // Normal case, nothing special to do. We can just set the point.
            m_topLeft = to.clone();
         } else {
            // The former bottom right corner is now the top right corner,
            // the specified point is the bottom left corner.
            m_topLeft.x = to.x;
            m_topLeft.y = m_bottomRight.y;

            // m_bottomRight.x is unchanged
            m_bottomRight.y = to.y;
         }
      } else {
         if( to.y <= m_bottomRight.y ) {
            // The former bottom right corner is now the bottom left corner,
            // the specified point is the top right corner.
            m_topLeft.x = m_bottomRight.y;
            m_topLeft.y = to.y;

            m_bottomRight.x = to.x;
            // m_bottomRight.y is unchanged.
         } else {
            // The former bottom right corner is now the top left corner,
            // the specified poiint is the bottom right corner.
            m_topLeft = m_bottomRight.clone();
            m_bottomRight = to.clone();
         }
      }*/
      // GRRR, think simple:
      setTop( to.x );
      setLeft( to.y );
   }


   public function getBottomRight() :Point2D {
      return m_bottomRight.clone();
   }

   /**
    * Sets the bottom right corner of the rectangle to the specified point.
    * If it is no longer the bottom right corner, the points are automatically
    * corrected.
    *
    * Note that the corner is set as a copy of the supplied point, you cannot
    * change it directly using the same reference afterwards.
    */
   public function setBottomRight( to :Point2D ) :Void {
      /*if ( m_topLeft.x <= to.x ) {
         if ( m_topLeft.y <= to.y ) {
            // Normal case, nothing special to do. We can just set the point.
            m_bottomRight = to.clone();
         } else {
            // The former upper left corner is now the bottom left corner,
            // the specified point is the top left corner.
            m_bottomRight.x = to.x;
            m_bottomRight.y = m_topLeft.y;

            // m_topLeft.x remains unchanged.
            m_topLeft.y = to.y;
         }
      } else {
         if( m_topLeft.y <= to.y ) {
            // The former top left corner is now the top right corner, the
            // specified point is the bottom left corner.
            m_bottomRight.x = m_topLeft.x;
            m_bottomRight.y = to.y;

            m_topLeft.x = to.x;
            // m_topLeft.y remains unchanged.
         } else {
            // The former top left corner is now the bottom right corner,
            // the specified point is the top left corner.
            m_bottomRight = m_topLeft.clone();
            m_topLeft = to.clone();
         }
      }*/
      // GRRR, think simple:
      setRight( to.x );
      setBottom( to.y );
   }

   public function setLeft( to :Number ) :Void {
      if ( to <= m_bottomRight.x ) {
         m_topLeft.x = to;
      } else {
         m_topLeft.x = m_bottomRight.x;
         m_bottomRight.x = to;
      }
   }

   public function setTop( to :Number ) :Void {
      if ( to <= m_bottomRight.y ) {
         m_topLeft.y = to;
      } else {
         m_topLeft.y = m_bottomRight.y;
         m_bottomRight.y = to;
      }
   }

   public function getRight() :Number {
      return m_bottomRight.x;
   }
   public function setRight( to :Number ) :Void {
      if ( m_topLeft.x <= to ) {
         m_bottomRight.x = to;
      } else {
         m_bottomRight.x = m_topLeft.x;
         m_topLeft.x = to;
      }
   }

   public function getBottom() :Number {
      return m_bottomRight.y;
   }
   public function setBottom( to :Number ) :Void {
      if ( m_topLeft.y <= to ) {
         m_bottomRight.y = to;
      } else {
         m_bottomRight.y = m_topLeft.y;
         m_topLeft.y = to;
      }
   }

   /**
    * Returns the rectangle's width.
    */
   public function getWidth() :Number {
      return m_bottomRight.x - m_topLeft.x;
   }

   /**
    * Returns the rectangle's height.
    */
   public function getHeight() :Number {
      return m_bottomRight.y - m_topLeft.y;
   }

   /**
    * Extends the borders of the rectangle by the specified width.
    * For example, if you extended the rectangle [(0,1);(4;4)] by 1 unit, you
    * would get [(-1,0);(5,5)].
    *
    * @param width The width to extend the rectangle.
    */
   public function extend( width :Number ) :Void {
      m_topLeft.x -= width;
      m_topLeft.y -= width;

      m_bottomRight.x += width;
      m_bottomRight.y += width;
   }

   /**
    * Test if the specified point lies in the rectangle.
    * If the point lies exactly on the border, it is also counted as inside the
    * rectangle.
    *
    * @param point The point to test.
    * @return If the point lies in the rectangle.
    */
   public function containsPoint( point :Point2D ) :Boolean {
      // topLeft and bottomRight cannot be swapped (there are checks in the
      // setter functions).
      if ( !( ( m_topLeft.x <= point.x ) && ( point.x <= m_bottomRight.x ) ) ) {
         return false;
      }
      if ( !( ( m_topLeft.y <= point.y ) && ( point.y <= m_bottomRight.y ) ) ) {
         return false;
      }

      return true;
   }

   /**
    * Extends the rectangle so that it contains the specified point afterwards.
    *
    * @param point The point that shall be in the rectangle afterwards.
    */
   public function extendToPoint( point :Point2D ) :Void {
      // If the point is already inside of the rectangle, we don't have to do
      // anything.
      if ( containsPoint( point ) ) {
         return;
      }

      if ( point.x < m_topLeft.x ) {
         m_topLeft.x = point.x;
      } else if ( m_bottomRight.x < point.x ) {
         m_bottomRight.x = point.x;
      }

      if ( point.y < m_topLeft.y ) {
         m_topLeft.y = point.y;
      } else if ( m_bottomRight.y < point.y ) {
         m_bottomRight.y = point.y;
      }
   }

   /**
    * Returns a flash-default rectangle (flash.geom.Rectangle) with the same
    * dimensions.
    *
    * @return The flash rectangle.
    */
   public function getFlashRect() :flash.geom.Rectangle {
      var flashRect :flash.geom.Rectangle = new flash.geom.Rectangle();
      flashRect.topLeft = m_topLeft.getFlashPoint();
      flashRect.bottomRight = m_bottomRight.getFlashPoint();
      return flashRect;
   }

   /**
    * Tests if this object has the same value as another Rect2D.
    *
    * @param other The object to test for equality.
    * @return If the objects have the same value.
    */
   public function equals( other :Rect2D ) :Boolean {
      return ( m_topLeft.equals( other.m_topLeft ) &&
         m_bottomRight.equals( other.m_bottomRight ) );
   }

   /**
    * Creates a copy of this object.
    *
    * @param deep Speciefies if a shallow or a deep copy will be created.
    *        Defaults to true (deep).
    * @return The copied object.
    */
   public function clone( deep :Boolean ) :Rect2D {
      if ( deep == null ) {
         deep = true;
      }

      var copy :Rect2D = new Rect2D();
      if ( deep ) {
         copy.m_topLeft = m_topLeft.clone();
         copy.m_bottomRight = m_bottomRight.clone();
      } else {
         copy.m_topLeft = m_topLeft;
         copy.m_bottomRight = m_bottomRight;
      }
      return copy;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "topLeft: " + m_topLeft,
         "bottomRight: " + m_bottomRight
      ] );
   }

   private var m_topLeft :Point2D;
   private var m_bottomRight :Point2D;
}
