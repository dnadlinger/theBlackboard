import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;

/**
 * A container for managing smooth showing and hiding of a component.
 *
 * When a Fader is created, the content component is put on stage as well, but
 * remains hidden until {@link #showContent} is called.
 */
class at.klickverbot.ui.components.Fader extends CustomSizeableComponent {
   public function Fader( content :IUiComponent ) {
      super();

      m_content = content;
      m_fadeDuration = DEFAULT_FADE_DURATION;
      m_runningFadeIn = null;
      m_runningFadeOut = null;
   }

   private function createUi() :Boolean {
      if ( !super.createUi() ) {
         return false;
      }

      if ( !m_content.create( m_container ) ) {
         return false;
      }
      updateSizeDummy();

      m_content.fade( 0 );

      return true;
   }

   public function destroy() :Void {
      if ( m_runningFadeIn != null ) {
         m_runningFadeIn.end();
      }
      if ( m_runningFadeOut != null ) {
         m_runningFadeOut.end();
      }

      m_content.destroy();
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      super.resize( width, height );
      m_content.setSize( getSize() );
   }

   /**
    * Shows the content component.
    *
    * If it is already fully visible or fading in, nothing happens. If it is
    * invisible, it is faded in. If it is currently fading out due to a previous
    * call to {@link #hideContent}, the fade-out is stopped and it is faded back
    * in.
    */
   public function showContent() :Void {
      Debug.assert( m_onStage, "Fader must be on stage to show content." );

      // If we are already fading in the component, just let it finish.
      if ( m_runningFadeIn != null ) return;

      // If the component is already visible, do nothing.
      if ( m_content.getAlpha() == 1 ) return;

      // Stop any running fade-outs and fade content back in again.
      if ( m_runningFadeOut != null ) {
         Animator.getInstance().stop( m_runningFadeOut );
         m_runningFadeOut = null;
      }

      // Using ( 1 - m_content.getAlpha() ) as factor for the fade duration is
      // merely an estimate because of the cubic time mapping applied, but the
      // difference should be virtually unnoticable in most cases.
      m_runningFadeIn = new Animation( new AlphaTween( m_content, 1 ),
         m_fadeDuration * ( 1 - m_content.getAlpha() ), TimeMappers.CUBIC );
      m_runningFadeIn.addEventListener( Event.COMPLETE, this, handleFadeInComplete );
      Animator.getInstance().run( m_runningFadeIn );
   }

   /**
    * Hides the content component.
    *
    * If it is already hidden, nothing happens. If it is currently fading in,
    * the fade is stopped and smoothly continued in the reverse direction.
    *
    * @param destroyFader If true, the Fader is completely destroyed once the
    *        fade-out has been finished. Defaults to <code>false</code>.
    */
   public function hideContent( destroyFader :Boolean ) :Void {
      if ( destroyFader == undefined ) {
         destroyFader = false;
      }

      // If we are already fading out the component, just let it finish.
      if ( m_runningFadeOut != null ) return;

      // If the component is still fading in, stop that animation.
      if ( m_runningFadeIn != null ) {
         Animator.getInstance().stop( m_runningFadeIn );
         m_runningFadeIn = null;
      }

      // Using m_content.getAlpha() as factor for the fade duration is merely
      // an estimate because of the cubic time mapping applied, but the
      // difference should be virtually unnoticable in most cases.
      m_runningFadeOut = new Animation( new AlphaTween( m_content, 0 ),
         m_fadeDuration * m_content.getAlpha(), TimeMappers.CUBIC );

      if ( destroyFader ) {
         m_runningFadeOut.addEventListener( Event.COMPLETE, this, destroy );
      } else {
         m_runningFadeOut.addEventListener( Event.COMPLETE, this, handleFadeOutComplete );
      }

      Animator.getInstance().run( m_runningFadeOut );
   }

   private function handleFadeInComplete() :Void {
      m_runningFadeIn.removeEventListener( Event.COMPLETE,
         this, handleFadeInComplete );
      m_runningFadeIn = null;
   }

   private function handleFadeOutComplete() :Void {
      m_runningFadeOut.removeEventListener( Event.COMPLETE,
         this, handleFadeOutComplete );
      m_runningFadeOut = null;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "content: " + m_content );
   }

   private static var DEFAULT_FADE_DURATION :Number = 0.5;

   private var m_content :IUiComponent;
   private var m_fadeDuration :Number;
   private var m_runningFadeIn :IAnimation;
   private var m_runningFadeOut :IAnimation;
}
