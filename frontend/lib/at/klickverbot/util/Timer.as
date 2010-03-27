import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.TimerEvent;

/**
 * Encapsulates the setInterval() and clearInterval() calls into a handy class.
 */
class at.klickverbot.util.Timer extends EventDispatcher {

   /**
    * Constructor.
    *
    * @param interval The timer interval in seconds.
    * @param numTriggerings The number of triggerings after which the timer is
    *    stopped (null for no limit).
    */
   public function Timer( interval :Number, numTriggerings :Number ) {
      m_running = false;
      m_interval = interval;

      m_triggeringCount = 0;
      m_numTriggerings = numTriggerings;
   }

   /**
    * Starts the timer.
    * Keep in mind that this function doesn't reset the triggering count.
    *
    * @return If the timer could be started (resp. if it was not already running)
    * @see #stop
    * @see #resetCount
    */
   public function start() :Boolean {
      // We can't start the timer if it's already running
      if ( m_running ) {
         return false;
      }

      m_timerId = setInterval( this, "intervalCallback", m_interval * 1000 );
      m_running = true;
   }

   /**
    * Stops the timer.
    * Keep in mind that this function doesn't reset the triggering count.
    *
    * @return If the timer could be stopped (resp. if it was running).
    * @see #start
    * @see #resetCount
    */
   public function stop() :Boolean {
      // We can't stop the timer if it isn't running
      if ( !m_running ) {
         return false;
      }

      clearInterval( m_timerId );
      m_running = false;
   }

   /**
    * Resets the triggering count to zero.
    * Timer must be stopped to do this.
    *
    * @return If the count was reset (if the timer was stopped).
    * @see #triggeringCount
    * @see #numTriggerings
    */
   public function resetCount() :Boolean {
      // The triggering count can't be reset when the timer is running.
      // This is a design choice – it may cause two extra code lines, but it is
      // better understandable.
      if ( m_running ) {
         return false;
      }

      m_triggeringCount = 0;
   }

   /**
    * Resets the timer.
    * This resets the counter and restarts the timer if it's running.
    */
   public function reset() :Void {
      var wasRunning :Boolean = m_running;
      if ( wasRunning ) {
         stop();
      }
      resetCount();
      if ( wasRunning ) {
         start();
      }
   }

   /**
    * The interval between timer triggerings in seconds.
    */
   public function get interval() :Number {
      return m_interval;
   }
   public function set interval( to :Number ) :Void {
      m_interval = to;
      if ( m_running ) {
         this.stop();
         this.start();
      }
   }

   /**
    * The number of triggerings after which the timer is stopped
    * (zero for no limit).
    */
   public function get numTriggerings() :Number {
      return m_numTriggerings;
   }
   public function set numTriggerings( to :Number ) :Void {
      // So trigger limit smaller than 0 (which means no limit) is possible
      if ( to < 0 ) {
         return;
      }

      m_numTriggerings = to;
   }

   /**
    * The current triggering count. (read-only)
    *
    * @see #numTriggerings
    */
   public function get triggeringCount() :Number {
      return m_triggeringCount;
   }

   /**
    * Signals if the timer is running. (read-only)
    *
    * @see #start
    * @see #stop
    */
    public function get isRunning() :Boolean {
       return m_running;
    }


   /**
    * Internal callback function.
    */
   private function intervalCallback() :Void {
      ++m_triggeringCount;
      if ( m_triggeringCount == m_numTriggerings ) {
         stop();
      }

      dispatchEvent( new TimerEvent( TimerEvent.TIMER, this, m_triggeringCount ) );
   }

   private var m_interval :Number;
   private var m_triggeringCount :Number;
   private var m_numTriggerings :Number;
   private var m_running :Boolean;
   private var m_timerId :Number;
}
