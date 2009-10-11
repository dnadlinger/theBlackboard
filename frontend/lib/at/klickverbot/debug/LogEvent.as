import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.LogLevel;

/**
 * Simple holder class for a log event consisting of the log's name, the level
 * at which the message was logged and the message itself.
 *
 * Has nothing to do with an at.klickverbot.event.* event that is dispatched
 * through an EventDispatcher.
 *
 */
class at.klickverbot.debug.LogEvent extends CoreObject {
   /**
    * Constructor.
    */
   public function LogEvent( logName :String, level :LogLevel,
      timestamp :Date, message :String ) {
      m_logName = logName;
      m_level = level;
      m_timestamp = timestamp;
      m_message = message;
   }

   public function get logName() :String {
      return m_logName;
   }
   public function set logName( to :String ) :Void {
      m_logName = to;
   }

   public function get level() :LogLevel {
      return m_level;
   }
   public function set level( to :LogLevel ) :Void {
      m_level = to;
   }

   public function get timestamp() :Date {
      return m_timestamp;
   }
   public function set timestamp( to :Date ) :Void {
      m_timestamp = to;
   }

   public function get message() :String {
      return m_message;
   }
   public function set message( to :String ) :Void {
      m_message = to;
   }

   private var m_logName :String;
   private var m_level :LogLevel;
   private var m_timestamp :Date;
   private var m_message :String;
}
