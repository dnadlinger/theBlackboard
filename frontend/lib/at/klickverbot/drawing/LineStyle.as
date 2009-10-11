import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;

class at.klickverbot.drawing.LineStyle extends CoreObject {
   /**
    * Constructor.
    *
    * @param thickness Thickness of the line in pt.
    * @param color Color of the line in rgb notation.
    * @param alpha Alpha of the line from 0 to 1.
    */
   public function LineStyle( thickness :Number, color :Number, alpha :Number ) {
      if ( thickness == null ) {
         thickness = DEFAULT_THICKNESS;
      }
      if ( color == null ) {
         color = DEFAULT_COLOR;
      }
      if ( alpha == null ) {
         alpha = DEFAULT_ALPHA;
      }

      // Use the public properties instead of the private member variables to
      // get the range checks.
      this.thickness = thickness;
      this.color = color;
      this.alpha = alpha;
   }

   /**
    * Sets the line style for the Flash vector drawing functions
    * (like <code>MovieClip.lineTo()</code>) of a specified MovieClip to this
    * style.
    *
    * @param target The MovieClip whose line style is set.
    */
   public function setTargetStyle( target :MovieClip ) :Void {
      target.lineStyle( m_thickness, m_color, m_alpha * 100 );
   }

   /**
    * Thickness of the line in pt.
    */
   public function get thickness() :Number {
      return m_thickness;
   }
   public function set thickness( to :Number ) : Void {
      Debug.assertPositive( to,
         "Line thickness must be positive, but is " + to + "!" );
      m_thickness = to;
   }

   /**
    * Color of the line in rgb notation.
    */
   public function get color() :Number {
      return m_color;
   }
   public function set color( to :Number ) :Void {
      Debug.assertInRange( 0x000000, to, 0xFFFFFF,
         "Not a valid line color: " + to.toString( 16 ) );
      m_color = to;
   }

   /**
    * Alpha of the line from 0-1 (100%).
    */
   public function get alpha() : Number {
      return m_alpha;
   }
   public function set alpha( to : Number ) :Void {
      Debug.assertInRange( 0, to, 1,
         "Line alpha must be between 0 and 1, but is " + to + "!" );
      m_alpha = to;
   }

   /**
    * Creates a independent (deep) copy of this object.
    *
    * @return The copied object.
    */
   public function clone() :LineStyle {
      var copy :LineStyle = new LineStyle();
      copy.m_thickness = m_thickness;
      copy.m_color = m_color;
      copy.m_alpha = m_alpha;
      return copy;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "thickness: " + m_thickness,
         "color: " + m_color.toString( 16 ),
         "alpha: " + m_alpha
      ] );
   }

   public static var DEFAULT_THICKNESS :Number = 0;
   public static var DEFAULT_COLOR :Number = 0x000000;
   public static var DEFAULT_ALPHA :Number = 1;

   private var m_thickness :Number;
   private var m_color :Number;
   private var m_alpha :Number;
}