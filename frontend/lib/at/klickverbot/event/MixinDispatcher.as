import at.klickverbot.event.EventDispatcher;
import at.klickverbot.util.Delegate;

/**
 * Adds support for acting like a mixin to the EventDispatcher.
 * Note that overwriteMethods is not static like the initialize() method from
 * the normal Flash EventDispatcher.
 *
 */
class at.klickverbot.event.MixinDispatcher extends EventDispatcher {
   public function overwriteMethods( target :Object ) :Void {
      target[ 'addEventListener' ] = Delegate.create( this, addEventListener );
      target[ 'removeEventListener' ] = Delegate.create( this, removeEventListener );
      target[ 'getListenerCount' ] = Delegate.create( this, getListenerCount );
      target[ 'dispatchEvent' ] = Delegate.create( this, dispatchEvent );
   }
}