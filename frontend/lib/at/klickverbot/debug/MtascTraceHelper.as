import at.klickverbot.debug.LogLevel;
import at.klickverbot.debug.Logger;

/**
 * A helper class that redirects all the trace calls to the logging system
 * using MTASC's custom trace function.
 *
 */
class at.klickverbot.debug.MtascTraceHelper {
   public static function log( message :String, callerName :String,
      fileName :String, lineNumber :Number ) :Void {
      Logger.getLog( "trace" ).log( LogLevel.DEBUG,
         callerName.split( "." ).pop() + ":" + lineNumber + ": " + message );
   }
}
