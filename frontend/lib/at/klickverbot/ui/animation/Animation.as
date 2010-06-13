import at.klickverbot.debug.Debug;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.ui.animation.ITween;
import at.klickverbot.ui.animation.timeMapping.ITimeMapper;
import at.klickverbot.ui.animation.timeMapping.LinearMapper;

class at.klickverbot.ui.animation.Animation extends EventDispatcher
   implements IAnimation {

   /**
    * Constructor.
    *
    * @param tween The tween for the animation.
    * @param duration The duration of the animation in seconds.
    * @param timeMapper Will be used for mapping animation time to tween time.
    */
   public function Animation( tween :ITween, duration :Number, timeMapper :ITimeMapper ) {
      m_tween = tween;
      m_duration = duration;

      if ( timeMapper == null ) {
         m_timeMapper = new LinearMapper();
      } else {
         m_timeMapper = timeMapper;
      }

      m_timeIndex = 0;
   }

   /**
    * Renders the animation.
    *
    * @param deltaTime The amount of time elapsed since the last call in seconds.
    *
    * @return The amount of time (in seconds) which was not "used" by the
    *    animation. This can only be not equal to 0 if the animation has ended.
    */
   public function tick( deltaTime :Number ) :Number {
      Debug.assertFalse( isCompleted(),
        "tick() must not be called on a completed Animation" );
      m_timeIndex += deltaTime / m_duration;

      if ( m_timeIndex >= 1 ) {
         var overrun :Number = ( m_timeIndex - 1 ) * m_duration;
         end();
         return overrun;
      } else {
         m_tween.render( m_timeMapper.map( m_timeIndex ) );
         return 0;
      }
   }

   /**
    * Jumps to the end state of the animation regardless of the current
    * position.
    *
    * This does not need to be equal to the end of the tween because the time
    * mapper used does not need to map animation time 1 to tween time 1.
    *
    * If the animation is already at its completed, nothing happens.
    */
   public function end() :Void {
      if ( m_timeIndex == 1 ) {
         // The animation is already completed, do nothing.
         return;
      }

      m_timeIndex = 1;
      m_tween.render( m_timeMapper.map( 1 ) );
      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   public function isCompleted() :Boolean {
      return ( m_timeIndex == 1 ) || ( m_duration == 0 );
   }

   public function rewind() :Void {
      m_timeIndex = 0;
      m_tween.render( m_timeMapper.map( 0 ) );
   }

   public function setTween( tween :ITween ) :Void {
      if ( m_timeIndex != 0 ) {
         Debug.LIBRARY_LOG.warn( "Setting the tween of an already started" +
            "Animation, could lead to unexpected results." );
      }
      m_tween = tween;
   }

   /**
    * Creates a shallow copy of this object.
    *
    * @return The copied object.
    */
   public function clone() :Animation {
      var copy :Animation = new Animation( m_tween, m_duration, m_timeMapper );
      copy.m_timeIndex = m_timeIndex;
      return copy;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "tween: " + m_tween,
         "timeIndex: " + m_timeIndex
      ] );
   }

   private var m_tween :ITween;
   private var m_duration :Number;
   private var m_timeMapper :ITimeMapper;

   // Position of the animation (0..1).
   private var m_timeIndex :Number;
}
