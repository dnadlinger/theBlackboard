import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;

/**
 * Container object to ensure type safety when storing the event listeners.
 */
class at.klickverbot.event.EventListener extends CoreObject {
   /**
    * Constructor.
    *
    * @param owner The owner of the listener function. This is needed because
    *        ActionScript 2 does not have real delegates/member function pointers.
    * @param func The listener function for the event.
    */
   public function EventListener( owner :Object, func :Function ) {
      m_owner = owner;
      m_func = func;
   }

   public function get owner() :Object {
      return m_owner;
   }
   public function set owner( to :Object ) :Void {
      Debug.assertNotNull( to, "The owner of the listener function " +
         "cannot be null!" );
      m_owner = to;
   }

   public function get func() :Function {
      return m_func;
   }
   public function set func( to :Function ) :Void {
      Debug.assertNotNull( to, "The listener function cannot be null!" );
      m_func = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "owner: " + m_owner,
         "func: " + func
      ] );
   }

   private var m_owner :Object;
   private var m_func :Function;
}