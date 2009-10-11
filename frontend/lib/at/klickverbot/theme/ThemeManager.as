import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.ThemeManagerEvent;
import at.klickverbot.theme.ITheme;

class at.klickverbot.theme.ThemeManager extends EventDispatcher {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ThemeManager() {
      // Will be set later...
      m_currentTheme = null;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of ThemeManager.
    */
   public static function getInstance() :ThemeManager {
      if ( m_instance == null ) {
         m_instance = new ThemeManager();
      }

      return m_instance;
   }

   /**
    * Returns the current theme as an ITheme object.
    *
    * @return The current theme.
    */
   public function getTheme() :ITheme {
      return m_currentTheme;
   }

   /**
    * Sets the current theme to the supplied ITheme.
    *
    * @param theme The new theme.
    */
   public function setTheme( theme :ITheme ) :Void {
      var oldTheme :ITheme = m_currentTheme;
      m_currentTheme = theme;

      dispatchEvent( new ThemeManagerEvent( ThemeManagerEvent.THEME_CHANGE,
         this, oldTheme, m_currentTheme ) );
   }


   private static var m_instance :ThemeManager;
   private var m_currentTheme :ITheme;
}