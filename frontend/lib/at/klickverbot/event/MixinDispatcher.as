import at.klickverbot.event.EventDispatcher;
import at.klickverbot.util.Delegate;

/**
 * Extends EventDispatcher so it can be used to »retroactively« add event
 * dispatching capabilities to an existing class.
 * 
 * This is useful in cases where one needs to derive a class from another base
 * class, but does not want to implement IEventDispatcher manually.
 */
class at.klickverbot.event.MixinDispatcher extends EventDispatcher {
	/**
	 * Binds the IEventDispatcher methods of the target object to this instance.
	 * 
	 * Note that this function is not static like <code>initialize()</code> from
	 * Macromedia's EventDispatcher, but is called on a specific MixinDispatcher
	 * instance.
	 */
   public function overwriteMethods( target :Object ) :Void {
      target[ 'addEventListener' ] =   
         Delegate.create( this, addEventListener );

      target[ 'removeEventListener' ] =
         Delegate.create( this, removeEventListener );

      target[ 'addUnhandledEventsListener' ] =
         Delegate.create( this, addUnhandledEventsListener );

      target[ 'removeUnhandledEventsListener' ] =
         Delegate.create( this, removeUnhandledEventsListener );

      target[ 'getListenerCount' ] =
         Delegate.create( this, getListenerCount );

      target[ 'dispatchEvent' ] =
         Delegate.create( this, dispatchEvent );
   }
}
