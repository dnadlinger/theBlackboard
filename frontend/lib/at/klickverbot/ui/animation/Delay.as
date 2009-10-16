import at.klickverbot.ui.animation.Sequence;
import at.klickverbot.event.events.Event;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.ui.animation.IAnimation;

class at.klickverbot.ui.animation.Delay extends EventDispatcher implements IAnimation {
   public function Delay( duration :Number ) {
      m_duration = duration;
      m_position = 0;
   }

   public static function preDelay( duration :Number, animation :IAnimation )
      :IAnimation {
      return new Sequence( [ new Delay( duration ), animation ] );
   }

   public function tick( deltaTime :Number ) :Number {
      m_position += deltaTime;

      if ( m_position >= m_duration ) {
         var overrun :Number = m_position - m_duration;
         end();
         return overrun;
      } else {
         return 0;
      }
   }

   public function end() :Void {
      m_position = m_duration;
      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   public function isCompleted() :Boolean {
      return ( m_position == m_duration );
   }

   public function rewind() :Void {
      m_position = 0;
   }

   private var m_duration :Number;
   private var m_position: Number;
}
