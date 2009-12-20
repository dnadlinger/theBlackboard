import at.klickverbot.ui.layout.VerticalPosition;
import at.klickverbot.ui.layout.verticalAlign.BottomAlign;
import at.klickverbot.ui.layout.verticalAlign.IVerticalAlign;
import at.klickverbot.ui.layout.verticalAlign.MiddleAlign;
import at.klickverbot.ui.layout.verticalAlign.TopAlign;

class at.klickverbot.ui.layout.verticalAlign.VerticalAligns {
   /**
    * Do not instanciate this class.
    */
   private function VerticalAligns() {
   }

   public static function fromPosition( position :VerticalPosition )
      :IVerticalAlign {
      if ( position == VerticalPosition.TOP ) {
         return TOP;
      } else if ( position == VerticalPosition.MIDDLE ) {
         return MIDDLE;
      } else if ( position == VerticalPosition.BOTTOM ) {
         return BOTTOM;
      }
   }

   public static var TOP :IVerticalAlign = new TopAlign();
   public static var MIDDLE :IVerticalAlign = new MiddleAlign();
   public static var BOTTOM :IVerticalAlign = new BottomAlign();
}
