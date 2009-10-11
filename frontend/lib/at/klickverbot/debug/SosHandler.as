import at.klickverbot.debug.AbstractLogHandler;
import at.klickverbot.debug.SosConnection;

/**
 * Log handler that sends the messages to SOS using <code>SosConnection</code>.
 *
 */
class at.klickverbot.debug.SosHandler extends AbstractLogHandler {
   /**
    * Constructor.
    */
   public function SosHandler() {
      super();
   }

   private function outputEvent( level :String, message :String ) :Void {
      SosConnection.getInstance().send( level, message );
   }
}
