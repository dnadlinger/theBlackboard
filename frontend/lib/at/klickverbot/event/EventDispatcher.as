import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.event.EventListener;
import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.event.events.Event;

/**
 * Minimalistic event dispatcher. Other than the GDispatcher and the standard
 * Flash EventDispatcher, this class is not directly used as a mixin.
 *
 * Loosely based on the EventDispatcher by Saban Ünlü that he presented at the
 * FlashForumKonferenz 2006.
 */
class at.klickverbot.event.EventDispatcher extends CoreObject
   implements IEventDispatcher {

   /**
    * Registers an event listener that recieves the dispatched events.
    *
    * There is no guarantee that the registered listeners are called in any
    * particular order when an event is dispatched to them.
    *
    * @param event The event to add the listener for.
    * @param listenerOwner The owner of the listener function. Only needed
    *        because ActionScript 2 allows no real function pointers.
    * @param listener The listener function that recieves the event.
    */
   public function addEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Void {
      if ( ( !( eventType.length > 0 ) ) || ( listener == null ) ) {
         Debug.LIBRARY_LOG.warn( "Attempted to add illegal listener to " + this +
            ": eventType: " + eventType + ", listenerOwner: " + listenerOwner +
            ", listener: " + listener );
         return;
      }

      if ( m_listeners == null ) {
         m_listeners = new Object();
      } else if ( removeEventListener( eventType, listenerOwner, listener ) ) {
         Debug.LIBRARY_LOG.debug( "Listener already exists, removing the old one " +
            "from " + this + ": eventType: " + eventType + ", listenerOwner: " +
            listenerOwner + ", listener: " + listener );
      }

      // Create listener array for this event type if it does not exit.
      var eventListeners :Array = m_listeners[ eventType ] || (
         m_listeners[ eventType ] = new Array() );

      eventListeners.push( new EventListener( listenerOwner, listener ) );
   }

   /**
    * Removes an event listener from the list.
    *
    * @return If the listener could be removed (if it was in the list).
    * @see #addEventListener
    */
   public function removeEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Boolean {
      if ( m_listeners == null ) {
         // Nothing to do, no registered listeners.
         return false;
      }

      var eventRemoved :Boolean = false;

      var currentListener :EventListener;
      var eventListeners :Array = getListenersForEvent( eventType );

      if ( eventListeners == null ) {
         // Nothing to do, no registered listeners for this event.
         return false;
      }

      // We need to traverse the m_listeners subarray to search for the listener
      // to remove. While we are at it, we can also check if any registered
      // listeners have ceased to exist. Because this should not happen anyway,
      // we go with a faster approach when not debugging. Inspired by Saban Ünlü.

      if ( Debug.LEVEL == DebugLevel.NONE ) {
         var i :Number = eventListeners.length;

         while ( currentListener = eventListeners[ --i ] ) {
            if ( ( currentListener.func === listener ) &&
               ( currentListener.owner === listenerOwner ) ) {

               eventListeners.splice( i, 1 );
               return true;
            }
         }
      } else {
         var listenerIndex :Number = 0;

         while ( listenerIndex < eventListeners.length ) {
            currentListener = eventListeners[ listenerIndex ];

            if ( ( currentListener.func === listener ) &&
               ( currentListener.owner === listenerOwner ) ) {
               eventListeners.splice( listenerIndex, 1 );
               eventRemoved = true;

               // We have to decrement the index value if we remove an element
               // from the array because we would skip the following element if
               // we did not.
               if ( listenerIndex > 0 ) {
                  --listenerIndex;
               }
            } else if ( ( currentListener.func == null ) ||
               ( currentListener.owner == null ) ) {
               eventListeners.splice( listenerIndex, 1 );

               if ( listenerIndex > 0 ) {
                  --listenerIndex;
               }

               Debug.LIBRARY_LOG.warn( "No longer existing event listener for " +
                  "event type " + eventType + " removed from " + this + "." );
            }

            ++listenerIndex;
         }
      }
      return eventRemoved;
   }

   /**
    * Registers an event listener that recieves all events not handled by
    * another listener. This is useful for implementing event bubbling.
    *
    * @param listenerOwner The owner of the listener function. Only needed
    *        because ActionScript 2 allows no real function pointers.
    * @param listener The listener function that recieves the event.
    */
   public function addUnhandledEventsListener( listenerOwner :Object,
      listener :Function ) :Void {

      if ( listener == null ) {
         Debug.LIBRARY_LOG.warn( "Attempted to add null listener to " + this +
            ": listenerOwner: " + listenerOwner + ", listener: " + listener );
         return;
      }

      if ( m_unhandledListeners == null ) {
         m_unhandledListeners = new Array();
      } else if ( removeUnhandledEventsListener( listenerOwner, listener ) ) {
         Debug.LIBRARY_LOG.debug( "Unhandled events listener already exists, " +
            "removing the old one from " + this + ", listenerOwner: " +
            listenerOwner + ", listener: " + listener );
      }

      m_unhandledListeners.push( new EventListener( listenerOwner, listener ) );
   }

   /**
    * Removes an event listener from the list of unhandled events listeners.
    *
    * @return If the listener could be removed (if it was in the list).
    * @see #addUnhandledEventsListener
    */
   public function removeUnhandledEventsListener( listenerOwner :Object,
      listener :Function ) :Boolean {

      if ( m_unhandledListeners == null ) {
         // Nothing to do, no unhandled events listeners registered.
         return false;
      }

      // We need to traverse m_unhandledListeners to search for the listener to
      // remove. While we are at it, we can also check if any registered
      // listeners have ceased to exist. Because this should not happen anyway,
      // we go with a faster approach when not debugging. Inspired by Saban Ünlü.

      var currentListener :EventListener;
      if ( Debug.LEVEL == DebugLevel.NONE ) {
         var i :Number = m_unhandledListeners.length;
         while ( currentListener = m_unhandledListeners[ --i ] ) {
            if ( ( currentListener.func === listener ) &&
               ( currentListener.owner === listenerOwner ) ) {

               m_unhandledListeners.splice( i, 1 );
               return true;
            }
         }
         return false;
      } else {
         var eventRemoved :Boolean = false;
         var listenerIndex :Number = 0;
         while ( listenerIndex < m_unhandledListeners.length ) {
            currentListener = m_unhandledListeners[ listenerIndex ];

            if ( ( currentListener.func === listener ) &&
               ( currentListener.owner === listenerOwner ) ) {
               m_unhandledListeners.splice( listenerIndex, 1 );
               eventRemoved = true;

               // We have to decrement the index value if we remove an element
               // from the array because we would skip the following element if
               // we did not.
               if ( listenerIndex > 0 ) {
                  --listenerIndex;
               }
            } else if ( ( currentListener.func == null ) ||
               ( currentListener.owner == null ) ) {
               m_unhandledListeners.splice( listenerIndex, 1 );

               if ( listenerIndex > 0 ) {
                  --listenerIndex;
               }

               Debug.LIBRARY_LOG.warn( "No longer existing unhandled event" +
                  "listener removed from " + this + "." );
            }

            ++listenerIndex;
         }
         return eventRemoved;
      }
   }

   /**
    * Returns the number of listeners that are registered for the given event
    * type.
    *
    * @param eventType The event type from which to get the number of listeners.
    * @return The number of listeners.
    */
   public function getListenerCount( eventType :String ) :Number {
      return getListenersForEvent( eventType ).length || 0;
   }

   /**
    * Dispatches event to all registered listeners.
    *
    * @param event An event object that is dispatched.
    */
   public function dispatchEvent( event :Event ) :Void {
      Debug.assertNotNull( event, "Attempted to dispatch null event." );

      if ( !dispatchEventToSpecificListeners( event ) ) {
         dispatchEventToUnhandledListeners( event );
      }
   }

   /**
    * Dispatches an event to all the event listeners registered specifically
    * for this event type (not counting unhandled events listeners).
    *
    * @return true if at least one listener was found, false otherwise.
    */
   private function dispatchEventToSpecificListeners( event :Event ) :Boolean {
      if ( m_listeners == null ) {
         // Nothing to do, no registered listeners at all.
         return false;
      }

      var eventListeners :Array = getListenersForEvent( event.type );
      if ( ( eventListeners == null ) || eventListeners.length == 0 ) {
         // No listeners registed for this event.
         return false;
      }
      
      // Operate on a private copy of the listeners array to avoid getting
      // confused if a listener is removed from the list while iterating it.
      var listenersCopy :Array = eventListeners.slice();

      // We need to traverse the m_listeners subarray to dispatch the event to
      // all listeners. While we are at it, we can also check if any registered
      // listeners have ceased to exist (for debugging purposes).
      var currentListener :EventListener;
      var listenerIndex :Number = listenersCopy.length;
      if ( Debug.LEVEL == DebugLevel.NONE ) {
         while ( currentListener = listenersCopy[ --listenerIndex ] ) {
            currentListener.func.call(
               currentListener.owner, event );
         }
      } else {
         while ( currentListener = listenersCopy[ --listenerIndex ] ) {
            if ( ( currentListener.func != null ) ) {
               currentListener.func.call(
                  currentListener.owner, event );
            } else {
               eventListeners.splice( listenerIndex, 1 );
               Debug.LIBRARY_LOG.warn( "No longer existing event listener " +
                  "for event " + event + " removed from " + this + "." );
            }
         }
      }

      return true;
   }

   /**
    * Dispatches an event to all the listeners for unhandled events.
    */
   private function dispatchEventToUnhandledListeners( event :Event ) :Void {
      if ( m_unhandledListeners == null ) {
         // No unhandled events listeners registered.
         return;
      }

      // We need to traverse m_unhandledListeners to dispatch the event to
      // all listeners. While we are at it, we can also check if any registered
      // listeners have ceased to exist. Because this should not happen anyway,
      // we go with a faster approach when not debugging. Inspired by Saban Ünlü.

      var currentListener :EventListener;
      if ( Debug.LEVEL == DebugLevel.NONE ) {
         var listenerCount :Number = m_unhandledListeners.length;

         while ( currentListener = m_unhandledListeners[ --listenerCount ] ) {
            currentListener.func.call( currentListener.owner, event );
         }
      } else {
         var listenerIndex :Number = 0;

         while ( listenerIndex < m_unhandledListeners.length ) {
            currentListener = m_unhandledListeners[ listenerIndex ];
            if ( ( currentListener.func != null ) ) {
               currentListener.func.call( currentListener.owner,
                  event );
            } else {
               m_unhandledListeners.splice( listenerIndex, 1 );

               if ( listenerIndex > 0 ) {
                  --listenerIndex;
               }

               Debug.LIBRARY_LOG.warn( "No longer existing unhandled event " +
                  "listener removed from " + this + "." );
            }

            ++listenerIndex;
         }
      }
   }

   /**
    * Wrapper for the "dirty" associative array access to ensure type safety.
    *
    * @param eventType The type of event to get all listeners of.
    * @return An Array containing all the listeners for the given event type.
    */
   private function getListenersForEvent( eventType :String ) :Array {
      return m_listeners[ eventType ];
   }

   // Associative array of all event listeners. 1st dimension: events by event
   // string; 2nd dimension: normal array containing all the listeners.
   private var m_listeners :Object;

   // Array of all the listeners for unhandled events.
   private var m_unhandledListeners :Array;
}
