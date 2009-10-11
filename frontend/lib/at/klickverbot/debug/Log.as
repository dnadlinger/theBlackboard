import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.ILogHandler;
import at.klickverbot.debug.LogEvent;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.debug.Logger;

/**
 * A log to which messages can be logged and listeners to this log events can
 * be attached. You should use <code>Logger.getLog()</code> instead of directly
 * creating an instance of this class.
 *
 * Note: This class is <b>very</b> sensitive to traces in the wrong place,
 * wrong calls to static classes, etc.
 *
 */
class at.klickverbot.debug.Log extends CoreObject {
   /**
    * Constructor.
    */
   public function Log( name :String ) {
      m_name = name;
      m_isAllLog = ( m_name == Logger.LOG_ALL );

      m_handlers = new Object();
      m_handlers[ LogLevel.FATAL.getName() ]= new Array();
      m_handlers[ LogLevel.ERROR.getName() ] = new Array();
      m_handlers[ LogLevel.WARN.getName() ] = new Array();
      m_handlers[ LogLevel.INFO.getName() ] = new Array();
      m_handlers[ LogLevel.DEBUG.getName() ] = new Array();
   }

   /**
    * Returns the name of the log.
    * Should not be really needed, just for the sake of completeness.
    *
    * @return The name of the log.
    */
   public function getName() :String {
      return m_name;
   }

   /**
    * Check if a log event at a specified level is actually recieved by any
    * log handler.
    * Useful to optimize situations where the log message requires a lot of
    * computing.
    *
    * @param level The log level to check.
    * @return If an event at the passed level will be logged.
    */
   public function isLevelLogged( level :LogLevel ) :Boolean {
      return ( handlersForLevel( level ).length > 0 ) ||
         ( ( m_isAllLog ? false : Logger.getAllLog().isLevelLogged( level ) ) );
   }

   /**
    * Log a message to this log at the specified log level.
    * Consider using <code>isLevelLogged</code> if the construction of the
    * message is computing-intensive to check if the message will actually be
    * noticed by any log handler.
    *
    * @param level The level at which the message is logged.
    * @param message The message to log.
    */
   public function log( level :LogLevel, message :String ) :Void {
      if ( level == null ) {
         level = LogLevel.DEBUG;
      } else if ( level == LogLevel.NONE ) {
         Debug.LIBRARY_LOG.log( LogLevel.DEBUG, "Trying to log message at " +
            "LogLevel.NONE to " + m_name + ", skipping..." );
         return;
      }

      var event :LogEvent = new LogEvent( m_name, level, new Date(),
         message );

      distributeEvent( event );
      if ( !m_isAllLog ) {
         Logger.getAllLog().distributeEvent( event );
      }
   }

   /**
    * Adds an <code>ILogHandler</code> to this log that recieves all log
    * events whose level is >= minLevel.
    * If the handler is already in the list, it is deleted and then added with
    * the new <code>minLevel</code>.
    *
    * @param handler The <code>ILogHandler</code> to add.
    * @param minLevel The minimum level for log events to be forwarded to the
    *        handler. Should not be <code>LogLevel.NONE</code> to make sense.
    *        If null is supplied, <code>LogLevel.DEBUG</code> is used instead.
    */
   public function addLogHandler( handler :ILogHandler, minLevel :LogLevel ) :Void {
      if ( handler == null ) {
         Debug.LIBRARY_LOG.log( LogLevel.INFO,
            "Trying to add null-handler to log " + m_name + ", skipping..." );
      }

      if ( minLevel == null ) {
         minLevel = LogLevel.DEBUG;
      } else if ( minLevel == LogLevel.NONE ) {
         Debug.LIBRARY_LOG.log( LogLevel.DEBUG, "Trying to add handler {"
            + handler + "} at LogLevel.NONE to log " + m_name + ", skipping..." );
         return;
      }

      removeLogHandler( handler );

      switch( minLevel ) {
         case LogLevel.DEBUG:
            handlersForLevel( LogLevel.DEBUG ).push( handler );
            // Fall through.

         case LogLevel.INFO:
            handlersForLevel( LogLevel.INFO ).push( handler );
            // Fall through.

         case LogLevel.WARN:
            handlersForLevel( LogLevel.WARN ).push( handler );
            // Fall through.

         case LogLevel.ERROR:
            handlersForLevel( LogLevel.ERROR ).push( handler );
            // Fall through.

         case LogLevel.FATAL:
            handlersForLevel( LogLevel.FATAL ).push( handler );
            break;

         default:
            Debug.LIBRARY_LOG.log( LogLevel.ERROR,
               "Invalid log level, should not be possible!" );
            break;
      }
   }

   /**
    * Removes a given <code>ILogHandler</code> from all logging levels.
    *
    * @param handler The handler to remove.
    * @return If the handler could be removed (if it was registered at any level).
    */
   public function removeLogHandler( handler :ILogHandler ) :Boolean {
      var levels :Array = [ LogLevel.FATAL, LogLevel.ERROR, LogLevel.WARN,
         LogLevel.INFO, LogLevel.DEBUG ];

      var currentLevelHandlers :Array;
      var found :Boolean = false;

      for ( var i :Number = 0; i < levels.length; ++i ) {
         currentLevelHandlers = handlersForLevel( levels[ i ] );

         for ( var j :Number = 0; j < currentLevelHandlers.length; ++j ) {
            if ( currentLevelHandlers[ j ] == handler ) {
               currentLevelHandlers.splice( j, 1 );
               found = true;
               break;
            }
         }
      }

      return found;
   }

   /**
    * Convinience wrapper to log a message at <code>LogLevel.DEBUG</code>.
    *
    * @param message The message to log.
    */
   public function debug( message :String ) :Void {
      log( LogLevel.DEBUG, message );
   }

   /**
    * Convinience wrapper to log a message at <code>LogLevel.INFO</code>.
    *
    * @param message The message to log.
    */
   public function info( message :String ) :Void {
      log( LogLevel.INFO, message );
   }

   /**
    * Convinience wrapper to log a message at <code>LogLevel.WARN</code>.
    *
    * @param message The message to log.
    */
   public function warn( message :String ) :Void {
      log( LogLevel.WARN, message );
   }

   /**
    * Convinience wrapper to log a message at <code>LogLevel.ERROR</code>.
    *
    * @param message The message to log.
    */
   public function error( message :String ) :Void {
      log( LogLevel.ERROR, message );
   }

   /**
    * Convinience wrapper to log a message at <code>LogLevel.FATAL</code>.
    *
    * @param message The message to log.
    */
   public function fatal( message :String ) :Void {
      log( LogLevel.FATAL, message );
   }

   private function distributeEvent( event :LogEvent ) :Void {
      var levelHandlers :Array = handlersForLevel( event.level );

      for ( var i :Number = 0; i < levelHandlers.length; ++i ) {
         levelHandlers[ i ].handleLogEvent( event );
      }
   }

   /**
    * Wrapper for the "dirty" associative array access to ensure type safety.
    *
    * @param eventType The LogLevel to get all handlers of.
    * @return An Array containing all the handlers for the given log level.
    */
   private function handlersForLevel( level :LogLevel ) :Array {
      return m_handlers[ level.getName() ];
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "name: " + m_name );
   }

   // Name of the log, will most likely show up in output.
   private var m_name :String;

   // Associative array for all log levels to store the hanlers in an array.
   private var m_handlers :Object;

   private var m_isAllLog :Boolean;
}
