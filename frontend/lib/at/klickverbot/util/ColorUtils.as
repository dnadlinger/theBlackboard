
class at.klickverbot.util.ColorUtils {
   /**
    * Converts a rgb color specification into an 24 bit (web) color code.
    *
    * @param r The red part of the color (0-1).
    * @param g The green part of the color (0-1).
    * @param b The blue part of the color (0-1).
    * @return The 3*8 = 24 bit color code (0xFF000 equals red, ...).
    */
   public static function rgbToHex( r :Number, g :Number, b :Number ) :Number {
      return ( ( 255 * r ) << 16 ) + ( ( 255 * g ) << 8 ) + ( 255 * b );
   }
}
