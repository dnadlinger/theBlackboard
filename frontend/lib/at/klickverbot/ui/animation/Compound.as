import at.klickverbot.debug.Debug;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.IAnimation;

/**
 * A compound animation consisting of several member animations which run
 * concurrently.
 *
 * It is considered completed if all the member animations have been completed.
 */
class at.klickverbot.ui.animation.Compound extends EventDispatcher
   implements IAnimation {

   public function Compound( members :Array ) {
      Debug.assertExcludes( members, null,
        "A parallel anmation must not include any null members." );

      m_members = members;

      // Keep track of the number of member animations which have already ended.
      var currentAnimation :IAnimation;
      var i :Number = m_members.length;
      while ( currentAnimation = m_members[ --i ] ) {
         currentAnimation.addEventListener( Event.COMPLETE,
            this, incrementCompletionCount );
      }

      resetCompletedCount();
   }

   public function tick( deltaTime :Number ) :Number {
      Debug.assertFalse( isCompleted(),
        "tick() must not be called on a completed compound animation." );

      var minOvershoot :Number = deltaTime;

      var currentAnimation :IAnimation;
      var i :Number = m_members.length;
      while ( currentAnimation = m_members[ --i ] ) {
         if ( !currentAnimation.isCompleted() ) {
            minOvershoot =
               Math.min( minOvershoot, currentAnimation.tick( deltaTime ) );
         }
      }

      if ( isCompleted() ) {
         dispatchEvent( new Event( Event.COMPLETE, this ) );
      }

      return minOvershoot;
   }

   public function end() :Void {
      var currentAnimation :IAnimation;
      var i :Number = m_members.length;
      while ( currentAnimation = m_members[ --i ] ) {
         if ( currentAnimation.isCompleted() ) {
            currentAnimation.end();
         }
      }

      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   public function isCompleted() :Boolean {
      return ( m_completedCount == m_members.length );
   }

   public function rewind() :Void {
      var currentAnimation :IAnimation;
      var i :Number = m_members.length;
      while ( currentAnimation = m_members[ --i ] ) {
         currentAnimation.rewind();
      }
   }

   private function resetCompletedCount() :Void {
      m_completedCount = 0;

      // We need to manually increment the completion count for animations with
      // zero duration, since they will never dispatch an Event.COMPLETE.
      var currentAnimation :IAnimation;
      var i :Number = m_members.length;
      while ( currentAnimation = m_members[ --i ] ) {
         if ( currentAnimation.isCompleted() ) {
            ++m_completedCount;
         }
      }
   }

   private function incrementCompletionCount() :Void {
      ++m_completedCount;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "members.length: " + m_members.length,
         "completedCount: " + m_completedCount
      ] );
   }

   private var m_members :Array;
   private var m_completedCount :Number;
}
