import at.klickverbot.debug.Debug;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.IAnimation;

class at.klickverbot.ui.animation.Sequence extends EventDispatcher
   implements IAnimation {
   public function Sequence( members :Array ) {
      Debug.assertExcludes( members, null,
         "A sequence must not include any null members." );
      m_members = members;
      m_currentIndex = 0;
   }

   public function tick( deltaTime :Number ) :Number {
      Debug.assertFalse( isCompleted(),
        "tick() must not be called on a completed Sequence." );

      // Check if the current animation is already completed. This could be the
      // case for animations with zero duration.
      if ( m_members[ m_currentIndex ].isCompleted() ) {
         ++m_currentIndex;
         if ( isCompleted() ) {
         	end();
         	return deltaTime;
         }
      }

      var overrun :Number = m_members[ m_currentIndex ].tick( deltaTime );
      if ( overrun > 0 ) {
         ++m_currentIndex;
         if ( isCompleted() ) {
            end();
            return overrun;
         } else {
         	return tick( overrun );
         }
      }

      // If we get here, there was zero overrun.
      return 0;
   }

   public function end() :Void {
   	dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   public function isCompleted() :Boolean {
      return ( m_currentIndex == m_members.length );
   }

   public function rewind() :Void {
      var currentMember :IAnimation;
      var i :Number = m_members.length;
      while ( currentMember = m_members[ --i ] ) {
         currentMember.rewind();
      }

      m_currentIndex = 0;
   }

   private var m_members :Array;
   private var m_currentIndex :Number;
}
