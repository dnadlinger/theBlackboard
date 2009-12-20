import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.verticalAlign.VerticalAlign;

class at.klickverbot.ui.layout.verticalAlign.MiddleAlign extends VerticalAlign {
   private function getY( component :IUiComponent, targetHeight :Number ) :Number {
      return ( targetHeight - component.getSize().y ) / 2;
   }
}
