import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.theBlackboard.Application;

class at.klickverbot.theBlackboard.ReleaseEntryPoint {
   /**
    * The entry point of the application when running in release mode.
    *
    * @param container The application's main MovieClip.
    *        Supplied by the compiler, usually _root.
    */
   public static function main( container :MovieClip ) :Void {
      // This is a constant and won't be touched from here on.
      Debug.LEVEL = DebugLevel.NONE;

      // Don't add any log handlers, all log messages will be discarded.

      // Create an instance of the application and run it.
      var application :Application = new Application( container );
      application.run();
   }
}
