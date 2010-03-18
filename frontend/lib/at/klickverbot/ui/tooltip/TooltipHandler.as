import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.TimerEvent;
import at.klickverbot.event.events.UiEvent;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.tooltip.TooltipManager;
import at.klickverbot.util.Timer;

/**
 * Private class used by TooltipManager for tooltip handling.
 */
class at.klickverbot.ui.tooltip.TooltipHandler extends CoreObject {
   public function TooltipHandler( target :IUiComponent, tooltip :IUiComponent ) {
      m_target = target;
      m_target.addEventListener( UiEvent.MOUSE_OVER,
         this, handleTargetMouseOver );
      m_target.addEventListener( UiEvent.MOUSE_OUT,
         this, handleTargetMouseOut );

      m_tooltip = tooltip;

      m_timer = new Timer( TooltipManager.getInstance().activationDelay, 1 );
      m_timer.addEventListener( TimerEvent.TIMER, this, showTooltip );
   }

   public function detach() :Void {
      m_target.removeEventListener( UiEvent.MOUSE_OVER,
         this, handleTargetMouseOver );
      m_target.removeEventListener( UiEvent.MOUSE_OUT,
         this, handleTargetMouseOut );
   }

   public function getTarget() :IUiComponent {
      return m_target;
   }

   private function handleTargetMouseOver( event :UiEvent ) :Void {
      m_timer.start();
   }

   private function handleTargetMouseOut( event :UiEvent ) :Void {
      if ( m_timer.isRunning ) {
         m_timer.stop();
      } else if ( m_tooltip.isOnStage() ) {
         m_tooltip.destroy();
         m_timer.reset();
      }
   }

   private function showTooltip() :Void {
      Debug.assertFalse( m_tooltip.isOnStage(), "Tooltip already on stage: " +
         this );

      var targetClip :MovieClip = TooltipManager.getInstance().targetClip;
      if ( !m_tooltip.create(
         targetClip, TooltipManager.getInstance().targetDepth ) ) {
         Debug.LIBRARY_LOG.warn(
            "Could not create tooltip component for " + this );
         return;
      }

      m_tooltip.move(
         targetClip._xmouse + TooltipManager.getInstance().xMouseOffset,
         targetClip._ymouse + TooltipManager.getInstance().yMouseOffset
      );

      m_tooltip.fade( 0 );
      Animator.getInstance().run(
         new Animation(
            new AlphaTween( m_tooltip, 1 ),
            TooltipManager.getInstance().fadeDuration,
            TimeMappers.CUBIC
         )
      );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "target: " + m_target,
         "tooltip: " + m_tooltip
      ] );
   }

   private var m_target :IUiComponent;
   private var m_tooltip :IUiComponent;
   private var m_timer :Timer;
}
