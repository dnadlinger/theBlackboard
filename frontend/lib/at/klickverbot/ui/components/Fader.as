import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.ui.components.Fader extends CustomSizeableComponent {
   public function Fader( content :IUiComponent ) {
      super();

      m_content = content;
      m_fadeDuration = DEFAULT_FADE_DURATION;
      m_runningFadeIn = null;
      m_runningFadeOut = null;
   }

   public function destroy() :Void {
      if ( m_runningFadeIn != null ) {
         m_runningFadeIn.end();
      }
      if ( m_runningFadeOut != null ) {
         m_runningFadeOut.end();
      }

      if ( m_content.isOnStage() ) {
         m_content.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      super.resize( width, height );

      if ( m_content.isOnStage() ) {
         m_content.setSize( getSize() );
      }
   }

   public function createContent() :Boolean {
      if ( m_runningFadeIn != null ) {
         // If we are already fading in the component, just let it finish.
         return true;
      }

      if ( m_runningFadeOut != null ) {
         Animator.getInstance().stop( m_runningFadeOut );
         m_runningFadeOut = null;
      } else {
         // There are no animations running.
         if ( m_content.isOnStage() ) {
            // The content is already on stage and fully visible, nothing to do.
            return true;
         } else {
            // Create the component and fade it in.
            if ( !m_content.create( m_container ) ) {
               return false;
            }

            m_content.setSize( getSize() );
            m_content.fade( 0 );
         }
      }

      // ( 1 - m_content.getAlpha() ) is just a cheap guess because of the cubic
      // time mapping applied, but it should suffice in most cases.
      m_runningFadeIn = new Animation( new AlphaTween( m_content, 1 ),
         m_fadeDuration * ( 1 - m_content.getAlpha() ), TimeMappers.CUBIC );
      m_runningFadeIn.addEventListener( Event.COMPLETE, this, handleFadeInComplete );
      Animator.getInstance().run( m_runningFadeIn );

      return true;
   }

   public function destroyContent( destroyFader :Boolean ) :Boolean {
      if ( destroyFader == null ) {
         destroyFader = false;
      }

      if ( !m_content.isOnStage() ) {
         // The content is not on stage, nothing to do.
         return true;
      }

      if ( m_runningFadeOut != null ) {
         // If we are already fading out the component, just let it finish.
         return true;
      }

      if ( m_runningFadeIn != null ) {
         Animator.getInstance().stop( m_runningFadeIn );
         m_runningFadeIn = null;
      }

      // m_content.getAlpha() is just a cheap guess because of the cubic time
      // mapping applied, but it should suffice in most cases.
      m_runningFadeOut = new Animation( new AlphaTween( m_content, 0 ),
         m_fadeDuration * m_content.getAlpha(), TimeMappers.CUBIC );

      m_runningFadeOut.addEventListener( Event.COMPLETE, this, handleFadeOutComplete );
      if ( destroyFader ) {
         m_runningFadeOut.addEventListener( Event.COMPLETE, this, destroy );
      }

      Animator.getInstance().run( m_runningFadeOut );

      return true;
   }

   private function handleFadeInComplete() :Void {
      m_runningFadeIn.removeEventListener( Event.COMPLETE, this, handleFadeInComplete );
      m_runningFadeIn = null;
   }

   private function handleFadeOutComplete() :Void {
      m_runningFadeOut.removeEventListener( Event.COMPLETE, this, handleFadeOutComplete );
      m_runningFadeOut = null;
      m_content.destroy();
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
