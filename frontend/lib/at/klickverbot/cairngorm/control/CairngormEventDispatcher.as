import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.core.CoreObject;
import at.klickverbot.event.EventDispatcher;

class at.klickverbot.cairngorm.control.CairngormEventDispatcher extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function CairngormEventDispatcher() {
      m_eventDispatcher = new EventDispatcher();
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of CairngormEventDispatcher.
    */
   public static function getInstance() :CairngormEventDispatcher {
      if ( m_instance == null ) {
         m_instance = new CairngormEventDispatcher();
      }
      return m_instance;
   }

   // The event dispatcher-related methods will be overwritten by the
   // MixinDispatcher. Only here to satisfy the compiler.
   public function addEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Void {
      m_eventDispatcher.addEventListener( eventType, listenerOwner, listener );
   }

   public function removeEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Boolean {
      return m_eventDispatcher.removeEventListener( eventType, listenerOwner, listener );
   }

   public function getListenerCount( eventType :String ) :Number {
      return m_eventDispatcher.getListenerCount( eventType );
   }

   public function dispatchEvent( event :CairngormEvent ) :Void {
      m_eventDispatcher.dispatchEvent( event );
   }

   private static var m_instance :CairngormEventDispatcher;
   private var m_eventDispatcher :EventDispatcher;
}
