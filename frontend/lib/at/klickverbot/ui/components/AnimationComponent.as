import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.ui.components.IUiComponent;

/**
 * Internal helper class for stack.
 *
 * Used in combination with an array to emulate a hash with IAnimations as key.
 */
class at.klickverbot.ui.components.AnimationComponent extends CoreObject {
   public function AnimationComponent( animation :IAnimation,
      component :IUiComponent ) {
      m_animation = animation;
      m_component = component;
   }

   public function get animation() :IAnimation {
      return m_animation;
   }
   public function set animation( to :IAnimation ) :Void {
      m_animation = to;
   }

   public function get component() :IUiComponent {
      return m_component;
   }
   public function set component( to :IUiComponent ) :Void {
      m_component = to;
   }

   private var m_animation :IAnimation;
   private var m_component :IUiComponent;
}
