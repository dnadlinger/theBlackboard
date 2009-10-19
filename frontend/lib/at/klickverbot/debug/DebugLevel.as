import at.klickverbot.core.CoreObject;

/**
 * Simple enumeration-substitute for the standard log levels.
 */
class at.klickverbot.debug.DebugLevel extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function DebugLevel( level :Number, name :String ) {
      m_level = level;
      m_name = name;
   }

   public function getName() :String {
      return m_name;
   }

   /**
    * Allows for comparability of DebugLevels using the built-in Flash operators
    * for Numbers (>, >=, …).
    */
   public function valueOf() :Number {
      return m_level;
   }

   public static var NONE :DebugLevel = new DebugLevel( 0, "NONE" );
   public static var NORMAL :DebugLevel = new DebugLevel( 10, "NORMAL" );
   public static var HIGH :DebugLevel = new DebugLevel( 20, "HIGH" );

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_name );
   }

   private var m_level :Number;
   private var m_name :String;
}
