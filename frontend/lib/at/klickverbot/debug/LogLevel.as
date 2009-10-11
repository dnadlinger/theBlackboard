import at.klickverbot.core.CoreObject;

/**
 * Simple enumeration-substitute for the standard log levels.
 *
 */
class at.klickverbot.debug.LogLevel extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function LogLevel( level :Number, name :String ) {
      m_level = level;
      m_name = name;
   }

   public function isGreaterEqual( other :LogLevel ) :Boolean {
      return m_level >= other.m_level;
   }

   public function getName() :String {
      return m_name;
   }

   public static var NONE :LogLevel = new LogLevel( 0, "NONE" );
   public static var FATAL :LogLevel = new LogLevel( 10, "FATAL" );
   public static var ERROR :LogLevel = new LogLevel( 20, "ERROR" );
   public static var WARN :LogLevel = new LogLevel( 30, "WARN" );
   public static var INFO :LogLevel = new LogLevel( 40, "INFO" );
   public static var DEBUG :LogLevel = new LogLevel( 50, "DEBUG" );

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_name );
   }

   private var m_level :Number;
   private var m_name :String;
}
