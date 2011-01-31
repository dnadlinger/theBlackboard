import at.klickverbot.core.ICoreInterface;
import at.klickverbot.event.events.Event;

/**
 * A generic event dispatcher to which listeners can be registered, which are
 * then notified when an event of the specified type is dispatched.
 * 
 * It also supports »catch-all« listeners for unhandled events, which is useful
 * for implementing event bubbling.
 */
interface at.klickverbot.event.IEventDispatcher extends ICoreInterface {
   /**
    * Registers an event listener that recieves the dispatched events.
    * 
    * The order in which listeners are called once an event is dispatched is
    * not specified.
    *
    * @param event The event to add the listener for.
    * @param listenerOwner The owner of the listener function. This is needed
    *        because ActionScript 2 does not have real delegates or member
    *        function pointers.
    * @param listener The listener function that recieves the event.
    */
   public function addEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Void;

   /**
    * Removes an event listener from the list.
    *
    * @return If the listener could be removed (if it was in the list).
    * @see #addEventListener
    */
   public function removeEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Boolean;

   /**
    * Registers an event listener that recieves all events not handled by
    * another listener. This is useful for implementing event bubbling.
    *
    * @param listenerOwner The owner of the listener function. This is needed
    *        because ActionScript 2 does not have real delegates or member
    *        function pointers.
    * @param listener The listener function that recieves the event.
    */
   public function addUnhandledEventsListener( listenerOwner :Object,
      listener :Function ) :Void;

   /**
    * Removes an event listener from the list of unhandled events listeners.
    *
    * @return If the listener could be removed (if it was in the list).
    * @see #addUnhandledEventsListener
    */
   public function removeUnhandledEventsListener( listenerOwner :Object,
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
    * This behaves atomically in the sense that adding or removing listeners
    * from inside invoked event listeners does not affect the currently running
    * dispatching process.
    *
    * @param event An event object that is dispatched.
    */
   public function dispatchEvent( event :Event ) :Void;
}
