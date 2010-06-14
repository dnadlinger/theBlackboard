import at.klickverbot.util.NumberUtils;
import at.klickverbot.core.CoreObject;

import flash.geom.Point;

/**
 * A point (in 2D space).
 * Actually this class had to be named 'Vector2D', but because there is not
 * even a real difference between a point and a vector, I was lazy and did
 * not rename it.
 *
 */
class at.klickverbot.graphics.Point2D extends CoreObject {

   /**
    * Constructor.
    *
    * @param x The x-coordinate of the point.
    * @param y The y-coordinate of the point.
    */
   public function Point2D( x :Number, y	 :Number ) {
      m_x = x;
      m_y = y;
   }

   /**
    * The x-coordinate of the point.
    */
   public function get x() :Number {
      return m_x;
   }
   public function set x( to :Number ) :Void {
      m_x = to;
   }

   /**
    * The y-coordinate of the point.
    */
   public function get y() :Number {
      return m_y;
   }
   public function set y( to :Number ) :Void {
      m_y = to;
   }

   public function getSqrLength() :Number {
      return ( m_x * m_x ) + ( m_y * m_y );
   }
   public function getLength() :Number {
      return Math.sqrt( getSqrLength() );
   }

   public function sqrDistanceTo( other :Point2D ) :Number {
      return difference( other ).getSqrLength();
   }
   public function distanceTo( other :Point2D ) :Number {
      return difference( other ).getLength();
   }

   /**
    * Returns the dot product with the other point/vector.
    */
   public function dot( other :Point2D ) :Number {
      return m_x * other.m_x + m_y * other.m_y;
   }

   /**
    * Adds another Point2D to this point.
    *
    * @param other The point to add to this point.
    */
   public function add( other :Point2D ) :Void {
      m_x += other.m_x;
      m_y += other.m_y;
   }

   /**
    * Adds another Point2D to this point and returns the sum as a new point.
    *
    * @param other The point to add to this point.
    * @return The sum of the two points.
    */
   public function sum( other :Point2D ) :Point2D {
      return new Point2D( m_x + other.m_x, m_y + other.m_y );
   }

   /**
    * Substacts another Point2D from this point.
    *
    * @param other The point to substract from this point.
    */
   public function substract( other :Point2D ) :Void {
      m_x -= other.m_x;
      m_y -= other.m_y;
   }

   /**
    * Substacts another Point2D from this point and returns the difference as a
    * new point.
    *
    * @param other The point to substract from this point.
    * @return The difference of the two points.
    */
   public function difference( other :Point2D ) :Point2D {
      return new Point2D( m_x - other.m_x, m_y - other.m_y );
   }

   /**
    * Multiplies the point (resp. its coordinates) with the given factors.
    *
    * @param xFactor The factor to multiply the x coordinate with.
    * @param yFactor The factor to multiply the y coordinate with. If omitted,
    *        xFactor is used for both coordinates.
    */
   public function scale( xFactor :Number, yFactor :Number ) :Void {
      if ( yFactor == null ) {
         yFactor = xFactor;
      }

      m_x *= xFactor;
      m_y *= yFactor;
   }

   /**
    * Multiplies the point (resp. its coordinates) with the given scalar and
    * returns the product as a new point.
    *
    * @param xFactor The factor to multiply the x coordinate with.
    * @param yFactor The factor to multiply the y coordinate with. If omitted,
    *        xFactor is used for both coordinates.
    * @return A Point2D containing the result if the multiplication.
    */
   public function product( xFactor :Number, yFactor :Number ) :Point2D {
      if ( yFactor == null ) {
         yFactor = xFactor;
      }
      return new Point2D( m_x * xFactor, m_y * yFactor );
   }

   /**
    * Returns a standard flash point (flash.geom.Point) with the same
    * coordinates.
    */
   public function getFlashPoint() :Point {
      return new Point( m_x, m_y );
   }

   /**
    * Tests if this object has the same value as another Point2D.
    *
    * @param other The object to test for equality.
    * @param strict Whether to test for strict numerical equality. By default,
    *    a comparison allowing for NumberUtils.EPSILON is used. (optional)
    * @return If the objects have the same value.
    */
   public function equals( other :Point2D, strict :Boolean ) :Boolean {
      if ( strict == null ) {
         strict = false;
      }

      if ( strict ) {
         return ( ( m_x == other.m_x ) && ( m_y == other.m_y ) );
      } else {
         return ( NumberUtils.fuzzyEquals( m_x, other.m_x ) &&
            NumberUtils.fuzzyEquals( m_y, other.m_y ) );
      }
   }

   /**
    * Creates a independent (deep) copy of this object.
    *
    * @return The copied object.
    */
   public function clone() :Point2D {
      var copy :Point2D = new Point2D();
      copy.m_x = m_x;
      copy.m_y = m_y;
      return copy;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "x: " + m_x,
         "y: " + m_y
      ] );
   }

   private var m_x :Number;
   private var m_y :Number;
}
