import at.klickverbot.core.ICoreInterface;
import at.klickverbot.event.events.Event;

/**
 * EventDispatcher interface.
 *
 */
interface at.klickverbot.event.IEventDispatcher extends ICoreInterface {
   /**
    * Registers an event listener that recieves the dispatched events.
    *
    * @param event The event to add the listener for.
    * @param listenerOwner The owner of the listener function. Only needed
    *        because ActionScript 2 allows no real function pointers.
    * @param listener The listener function that recieves the event.
    */
   public function addEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Void;

   /**
    * Removes an event listener from the list.
    *
    * @return If the listener could be removed (if it was in the list).
    * @see{ #addEventListener }
    */
   public function removeEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Boolean;

   /**
    * Returns the number of handler functions that are registered for the
    * given event.
    *
    * @param eventType The event type from which to get the number of listeners.
    * @return The number of listeners.
    */
   public function getListenerCount( eventType :String ) :Number;

   /**
    * Dispatches event to all registered listeners.
    *
    * @param event An event object that is dispatched.
    */
   public function dispatchEvent( event :Event ) :Void;
}