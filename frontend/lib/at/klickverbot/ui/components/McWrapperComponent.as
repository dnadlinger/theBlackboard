import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;

/**
 * Wraps a "normal" MovieClip for use in the at.klickverbot UI subsystem.
 *
 * Should only be used as an adapter to plug clips created in the Flash
 * authoring software into the at.klickverbot.ui system.
 */
class at.klickverbot.ui.components.McWrapperComponent extends McComponent
   implements IUiComponent {

   /**
    * Constructor.
    */
   public function McWrapperComponent( wrappedClip :MovieClip ) {
      super();
      m_container = wrappedClip;

      // Since we are wrapping a MovieClip on the stage, we are always on stage.
      m_onStage = true;
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      // Do nothing.
      return true;
   }

   public function destroy() :Void {
      // Do nothing.
   }
}
