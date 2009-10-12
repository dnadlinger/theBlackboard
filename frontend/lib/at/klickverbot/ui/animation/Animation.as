import at.klickverbot.debug.Debug;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.ITween;
import at.klickverbot.ui.animation.timeMapping.ITimeMapper;
import at.klickverbot.ui.animation.timeMapping.LinearMapper;

class at.klickverbot.ui.animation.Animation extends EventDispatcher
   implements IEventDispatcher {

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
    */
   public function tick( deltaTime :Number ) :Void {
      m_timeIndex += deltaTime / m_duration;
      m_timeIndex = Math.min( m_timeIndex, 1 );

      m_tween.render( m_timeMapper.map( m_timeIndex ) );

      if ( m_timeIndex == 1 ) {
         dispatchEvent( new Event( Event.COMPLETE, this ) );
      }
   }

   /**
    * Jumps to the end state of the animation resp. the tween regardless of the
    * current position.
    */
   public function end() :Void {
      m_tween.render( 1 );
      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   public function isCompleted() :Boolean {
      return ( m_timeIndex == 1 ) || ( m_duration == 0 );
   }

   public function rewind() :Void {
      m_timeIndex = 0;
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

   private var m_tween :ITween;
   private var m_duration :Number;
   private var m_timeMapper :ITimeMapper;

   // Position of the animation (0..1).
   private var m_timeIndex :Number;
}
