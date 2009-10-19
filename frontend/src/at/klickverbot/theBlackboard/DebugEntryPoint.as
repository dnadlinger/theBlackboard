import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.debug.ILogHandler;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.debug.Logger;
import at.klickverbot.debug.SosHandler;
import at.klickverbot.theBlackboard.Application;

class at.klickverbot.theBlackboard.DebugEntryPoint {
   /**
    * The entry point of the application when running in debug mode.
    *
    * @param container The application's main MovieClip.
    *        Supplied by the compiler, usually _root.
    */
   public static function main( container :MovieClip ) :Void {
      // This is a constant and won't be touched from here on.
      Debug.LEVEL = DebugLevel.HIGH;

      // Send all log output (including traces) to Sos.
      var allHandler :ILogHandler = new SosHandler();
      Logger.getAllLog().addLogHandler( allHandler, LogLevel.DEBUG );

      // Create an instance of the application and run it.
      var application :Application = new Application( container );
      application.run();
   }
}
