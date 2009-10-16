import at.klickverbot.core.CoreObject;

class at.klickverbot.graphics.Color extends CoreObject {
   /**
    * Constructor.
    */
   public function Color( r :Number, g :Number, b :Number ) {
      m_r = r;
      m_g = g;
      m_b = b;
   }

   public static function fromBytes( rByte :Number, gByte :Number,
      bByte :Number ) :Color {
      return new Color( rByte / 255, gByte / 255, bByte / 255 );
   }

   public static function lerp( startColor :Color, endColor :Color,
      index :Number ) :Color {
      return new Color(
         ( 1 - index ) * startColor.m_r + index * endColor.m_r,
         ( 1 - index ) * startColor.m_g + index * endColor.m_g,
         ( 1 - index ) * startColor.m_b + index * endColor.m_b
      );
   }

   /**
    * Converts a rgb color specification into an 24 bit (web) color code.
    *
    * @param r The red part of the color (0-1).
    * @param g The green part of the color (0-1).
    * @param b The blue part of the color (0-1).
    * @return The 3*8 = 24 bit color code (0xFF0000 equals red, ...).
    */
   public function toHex() :Number {
      return ( ( 255 * m_r ) << 16 ) + ( ( 255 * m_g ) << 8 ) + ( 255 * m_b );
   }

   public function get r() :Number {
      return m_r;
   }
   public function set r( to :Number ) :Void {
      m_r = to;
   }

   public function get g() :Number {
      return m_g;
   }
   public function set g( to :Number ) :Void {
      m_g = to;
   }

   public function get b() :Number {
      return m_b;
   }
   public function set b( to :Number ) :Void {
      m_b = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(
         [ "r: " + m_r, "g: " + m_g, "b: " + m_b ] );
   }

   private var m_r :Number;
   private var m_g :Number;
   private var m_b :Number;

}
