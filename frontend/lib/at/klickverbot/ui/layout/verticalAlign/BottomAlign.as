import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.verticalAlign.VerticalAlign;

class at.klickverbot.ui.layout.verticalAlign.BottomAlign extends VerticalAlign {
   private function getY( component :IUiComponent, targetHeight :Number ) :Number {
      return targetHeight - component.getSize().y;
   }
}
