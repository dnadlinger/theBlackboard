import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;

/**
 * An container object to ensure type safety for storing the event listeners.
 * Alternatively we could use a dimension more in the listener array...
 *
 */
class at.klickverbot.event.EventListener extends CoreObject {
   /**
    * Constructor.
    *
    * @param listenerOwner The owner of the listener function. Only needed
    *        because ActionScript 2 allows no real function pointers.
    * @param listenerFunc The listener function for the event.
    */
   public function EventListener( listenerOwner :Object, listenerFunc :Function ) {
      m_listenerOwner = listenerOwner;
      m_listenerFunc = listenerFunc;
   }

   public function get listenerOwner() :Object {
      return m_listenerOwner;
   }
   public function set listenerOwner( to :Object ) :Void {
      Debug.assertNotNull( to, "The owner of the listener function " +
         "cannot be null!" );
      m_listenerOwner = to;
   }

   public function get listenerFunc() :Function {
      return m_listenerFunc;
   }
   public function set listenerFunc( to :Function ) :Void {
      Debug.assertNotNull( to, "The listener function cannot be null!" );
      m_listenerFunc = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "listenerOwner: " + m_listenerOwner,
         "listenerFunc: " + listenerFunc
      ] );
   }

   private var m_listenerOwner :Object;
   private var m_listenerFunc :Function;
}