import at.klickverbot.ui.layout.horizontalAlign.CenterAlign;
import at.klickverbot.ui.layout.HorizontalPosition;
import at.klickverbot.ui.layout.horizontalAlign.IHorizontalAlign;
import at.klickverbot.ui.layout.horizontalAlign.LeftAlign;
import at.klickverbot.ui.layout.horizontalAlign.RightAlign;

class at.klickverbot.ui.layout.horizontalAlign.HorizontalAligns {
   /**
    * Do not instanciate this class.
    */
   private function HorizontalAligns() {
   }

   public static function fromPosition( position :HorizontalPosition )
      :IHorizontalAlign {
      if ( position == HorizontalPosition.LEFT ) {
         return LEFT;
      } else if ( position == HorizontalPosition.CENTER ) {
         return CENTER;
      } else if ( position == HorizontalPosition.RIGHT ) {
         return RIGHT;
      }
   }

   public static var LEFT :IHorizontalAlign = new LeftAlign();
   public static var CENTER :IHorizontalAlign = new CenterAlign();
   public static var RIGHT :IHorizontalAlign = new RightAlign();
}
