import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Tint;
import at.klickverbot.ui.animation.ITween;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.ui.animation.TintTween extends CoreObject implements ITween {
   public function TintTween( target :IUiComponent, endTint :Tint,
      startTint :Tint ) {
      if ( startTint == null ) {
         startTint = target.getTint();
      }

      Debug.assertNotNull( target, "TintTween target must not be null." );

      m_target = target;
      m_startTint = startTint;
      m_endTint = endTint;
   }

   public function render( timeIndex :Number ) :Void {
      m_target.tint( Tint.lerp( m_startTint, m_endTint, timeIndex ) );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [ "target: " + m_target,
         "startTint: " + m_startTint, "endTint" + m_endTint ] );
   }

   private var m_target :IUiComponent;
   private var m_startTint :Tint;
   private var m_endTint :Tint;
}
