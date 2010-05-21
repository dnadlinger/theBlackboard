import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.verticalAlign.IVerticalAlign;

class at.klickverbot.ui.layout.verticalAlign.VerticalAlign
   extends CoreObject implements IVerticalAlign {

   public function move( component :IUiComponent, targetHeight :Number ) :Void {
      var componentHeight :Number = component.getSize().y;
      if ( targetHeight < componentHeight ) {
         Debug.LIBRARY_LOG.warn( "Component " + component +
            " too big to align: " + "component height: " + componentHeight +
            ", targetHeight: " + targetHeight + " (" + this + ")" );
      }

      var position :Point2D = component.getPosition();
      position.y = getY( component, targetHeight );
      component.setPosition( position );
   }

   private function getY( component :IUiComponent, targetHeight :Number ) :Number {
      Debug.pureVirtualFunctionCall( "VerticalAlign.getY" );
      return 0;
   }
}
