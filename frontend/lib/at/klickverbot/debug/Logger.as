import at.klickverbot.debug.Log;

/**
 * Easy-to-use static logger class for retrieving a named log instance.
 *
 */
class at.klickverbot.debug.Logger {
   public static function getLog( name :String ) :Log {
      if ( m_logs == null ) {
         m_logs = new Object();
      }

      if ( m_logs[ name ] == null ) {
         m_logs[ name ] = new Log( name );
      }

      return m_logs[ name ];
   }

   public static function getAllLog() :Log {
      return getLog( LOG_ALL );
   }

   public static var LOG_ALL :String = "ALL";

   private static var m_logs :Object;
}
