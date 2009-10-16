import at.klickverbot.debug.Debug;
import at.klickverbot.core.CoreObject;
import at.klickverbot.graphics.Color;

import flash.geom.ColorTransform;

class at.klickverbot.graphics.Tint extends CoreObject {
   /**
    * Constructor.
    */
   public function Tint( color :Color, amount :Number ) {
      m_color = color;
      m_amount = amount;
   }

   public static function lerp( startTint :Tint, endTint :Tint,
      index :Number ) :Tint {
      var color :Color = Color.lerp( startTint.color, endTint.color, index );
      var amount :Number = ( 1 - index ) * startTint.amount +
         index * endTint.amount;
      return new Tint( color, amount );
   }

   /**
    * Note: This only works as long as the ColorTransform contains only a
    * tinting transformation.
    */
   public static function fromColorTransform( transform :ColorTransform ) :Tint {
      Debug.assertEqual( transform.redOffset, transform.greenOffset,
         "The ColorTransform must contain only a tinting transformation." );
      Debug.assertEqual( transform.redOffset, transform.blueOffset,
         "The ColorTransform must contain only a tinting transformation." );

      // We could use any other channel to get the amount too.
      var amount :Number = 1 - transform.redMultiplier;
      var color :Color;
      if ( amount == 0 ) {
         Debug.LIBRARY_LOG.warn( "Reading tint from ColorTransform with " +
            "zero amount. Assuming Color( 1, 1, 1 )." );
         color = new Color( 1, 1, 1 );
      } else {
         color = Color.fromBytes(
            transform.redOffset / amount,
            transform.greenOffset / amount,
            transform.blueOffset / amount
         );
      }

      return new Tint( color, amount );
   }

   public function get color() :Color {
      return m_color;
   }
   public function set color( to :Color ) :Void {
      m_color = to;
   }

   public function get amount() :Number {
      return m_amount;
   }
   public function set amount( to :Number ) :Void {
      m_amount = to;
   }

   public function getColorTransform() :ColorTransform {
      return new ColorTransform(
         1 - m_amount,
         1 - m_amount,
         1 - m_amount,
         1,
         m_color.r * 255 * m_amount,
         m_color.g * 255 * m_amount,
         m_color.b * 255 * m_amount,
         0
      );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(
         [ "color: " + m_color, "amount: " + m_amount ] );
   }

   private var m_color :Color;
   private var m_amount :Number;
}
