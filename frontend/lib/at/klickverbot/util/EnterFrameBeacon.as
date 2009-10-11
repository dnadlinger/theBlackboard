import at.klickverbot.util.DummyClipManager;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.Event;
import at.klickverbot.util.Delegate;

/**
 * Singleton EventDispatcher that broadcasts <code>Event.ENTER_FRAME</code>
 * every frame. Useful for <code>onEnterFrame</code>-like functions in classes
 * that do not extend MovieClip.
 *
 */
class at.klickverbot.util.EnterFrameBeacon extends EventDispatcher {

   /**
    * Private constructor for singleton pattern – no-one except the class itself
    * can create an object of this class.
    */
   private function EnterFrameBeacon() {
      // Create empty movie clip as trigger for onEnterFrame
      m_movieClip = DummyClipManager.getInstance().createClip();
      m_movieClip.onEnterFrame = Delegate.create( this, onEnterFrame );
   }

   /**
    * Return the only instance of this class (singleton-pattern).
    */
   static public function getInstance() :EnterFrameBeacon {
      if ( m_instance == undefined ) {
         m_instance = new EnterFrameBeacon();
      }
      return m_instance;
   }

   /**
    * Is called every frame by the embedded helper MovieClip and broadcasts
    * the event to the registered listeners.
    */
   private function onEnterFrame() :Void {
      dispatchEvent( new Event( Event.ENTER_FRAME, this ) );
   }

   private var m_movieClip :MovieClip;
   static private var m_instance :EnterFrameBeacon;
}