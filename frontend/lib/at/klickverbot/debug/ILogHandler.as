import at.klickverbot.core.ICoreInterface;
import at.klickverbot.debug.LogEvent;

/**
 * Represents a class that can handle LogEvents and can be registered with a
 * <code>at.klickverbot.debug.Log</code>.
 *
 */
interface at.klickverbot.debug.ILogHandler extends ICoreInterface {
   public function handleLogEvent( event :LogEvent ) :Void;
}
