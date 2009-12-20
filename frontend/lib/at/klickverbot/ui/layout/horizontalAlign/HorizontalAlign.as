import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.horizontalAlign.IHorizontalAlign;

class at.klickverbot.ui.layout.horizontalAlign.HorizontalAlign
   extends CoreObject implements IHorizontalAlign {

   public function move( component :IUiComponent, targetWidth :Number ) :Void {
      var componentWidth :Number = component.getSize().x;
      if ( targetWidth < componentWidth ) {
         Debug.LIBRARY_LOG.warn( "Component " + component +
            " too big to align: " + "component width: " + componentWidth +
            ", targetWidth: " + targetWidth + " (" + this + ")" );
      }

      var position :Point2D = component.getPosition();
      position.x = getX( component, targetWidth );
      component.setPosition( position );
   }

   private function getX( component :IUiComponent, targetWidth :Number ) :Number {
      Debug.pureVirtualFunctionCall( "HorizontalAlign.getX" );
      return 0;
   }
}
