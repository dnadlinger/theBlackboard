import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.ILogHandler;
import at.klickverbot.debug.LogEvent;
import at.klickverbot.util.NumberUtils;

class at.klickverbot.debug.AbstractLogHandler extends CoreObject
   implements ILogHandler {

   /**
    * Constructor.
    * Private to prohibit instantiation of this abstract base class.
    */
   private function AbstractLogHandler() {
      m_showLogName = true;
      m_showTimestamp = true;
   }

   public function handleLogEvent( event :LogEvent ) :Void {
      var message :String = "";

      if ( m_showTimestamp ) {
         message += NumberUtils.numberToString( event.timestamp.getHours(), 2 );
         message += ":";
         message += NumberUtils.numberToString( event.timestamp.getMinutes(), 2 );
         message += ":";
         message += NumberUtils.numberToString( event.timestamp.getSeconds(), 2 );
         message += " ";
      }

      if ( m_showLogName ) {
         message += "[" + event.logName + "] ";
      }

      message += event.message;

      outputEvent( event.level.getName(), message );
   }

   public function get showLogName() :Boolean {
      return m_showLogName;
   }
   public function set showLogName( to :Boolean ) :Void {
      m_showLogName = to;
   }

   private function outputEvent( level :String, message :String ) :Void {
      // To be overwritten in subclasses.
      Debug.pureVirtualFunctionCall( "at.klickverbot.debug." +
         "AbstractLogHandler.outputEvent()" );
   }

   private var m_showLogName :Boolean;
   private var m_showTimestamp :Boolean;
}
