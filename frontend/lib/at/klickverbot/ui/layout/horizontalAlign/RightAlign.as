import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.horizontalAlign.HorizontalAlign;

class at.klickverbot.ui.layout.horizontalAlign.RightAlign extends HorizontalAlign {
   private function getX( component :IUiComponent, targetWidth :Number ) :Number {
     return targetWidth - component.getSize().x;
   }
}
