import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;

class at.klickverbot.drawing.FillStyle extends CoreObject {
   /**
    * Constructor.
    *
    * @param color Color of the filling in rgb notation.
    * @param alpha Alpha of the filling from 0 to 100%.
    */
   public function FillStyle( color :Number,	alpha :Number ) {
      if ( color == null ) {
         color = DEFAULT_COLOR;
      }
      if ( alpha == null ) {
         alpha = DEFAULT_ALPHA;
      }

      // Use the public properties instead of the private member variables to
      // get the range checks.
      this.color = color;
      this.alpha = alpha;
   }

   /**
    * Begins a new drawing path for the Flash vector drawing functions with
    * this filling at the target MovieClip using the
    * <code>MovieClip.beginFill()</code> method.
    *
    * @param target The MovieClip where the filling is begun.
    */
   public function beginFillAtTarget( target :MovieClip ) :Void {
      target.beginFill( m_color, m_alpha * 100 );
   }

   /**
    * Color of the filling in rgb notation.
    */
   public function get color() :Number {
      return m_color;
   }
   public function set color( to :Number ) :Void {
      Debug.assertInRange( 0x000000, to, 0xFFFFFF,
         "Not a valid color: " + to.toString( 16 ) );

      m_color = to;
   }

   /**
    * Alpha of the filling from 0-1 (100%).
    */
   public function get alpha() : Number {
      return m_alpha;
   }
   public function set alpha( to : Number ) :Void {
      Debug.assertInRange( 0, to, 1,
         "Filing alpha must be between 0 and 1, but is " + to + "!" );
      m_alpha = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "color: " + m_color.toString( 16 ),
         "alpha: " + m_alpha
      ] );
   }

   public static var DEFAULT_COLOR :Number = 0x000000;
   public static var DEFAULT_ALPHA :Number = 100;

   private var m_color :Number;
   private var m_alpha :Number;
}