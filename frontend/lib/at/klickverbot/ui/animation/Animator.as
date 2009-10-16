import at.klickverbot.core.CoreObject;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.util.EnterFrameBeacon;

class at.klickverbot.ui.animation.Animator extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function Animator() {
      m_animations = new Array();
      m_running = false;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The global Animator instance.
    */
   public static function getInstance() :Animator {
      if ( m_instance == null ) {
         m_instance = new Animator();
      }
      return m_instance;
   }

   public function add( animation :IAnimation ) :Void {
      // TODO: Check if animation is already added.
      // TODO: Reset animation first?

      // If the animation is already completed (i.e. its duration is zero), we
      // don't need to put it into the render process.
      if ( animation.isCompleted() ) {
         animation.end();
      } else {
         animation.addEventListener( Event.COMPLETE, this, handleAnimationCompleted );
         m_animations.push( animation );

         if ( !m_running ) {
            startEnterFrame();
         }
      }
   }

   // TODO: Add some means to stop an animation.

   private function render( event :Event ) :Void {
      var deltaTime :Number = ( getTimer() - m_lastTicks ) * 0.001;
      m_lastTicks = getTimer();

      var currentAnimation :Animation;
      var i :Number = m_animations.length;

      while ( currentAnimation = m_animations[ --i ] ) {
         currentAnimation.tick( deltaTime );
      }
   }

   private function startEnterFrame() :Void {
      EnterFrameBeacon.getInstance().addEventListener( Event.ENTER_FRAME,
         this, render );
      m_lastTicks = getTimer();
      m_running = true;
   }

   private function stopEnterFrame() :Void {
      EnterFrameBeacon.getInstance().removeEventListener( Event.ENTER_FRAME,
         this, render );
      m_running = false;
   }

   private function handleAnimationCompleted( event :Event ) :Void {
      var currentAnimation :IAnimation;
      var i :Number = m_animations.length;

      while ( currentAnimation = m_animations[ --i ] ) {
         if ( event.target == currentAnimation ) {
            m_animations.splice( i, 1 );

            if ( m_animations.length == 0 ) {
               stopEnterFrame();
            }

            return;
         }
      }
   }

   private static var m_instance :Animator;

   private var m_animations :Array;
   private var m_running :Boolean;
   private var m_lastTicks :Number;
}
