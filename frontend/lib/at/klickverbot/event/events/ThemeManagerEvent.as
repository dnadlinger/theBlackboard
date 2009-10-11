import at.klickverbot.event.events.Event;
import at.klickverbot.theme.ITheme;

class at.klickverbot.event.events.ThemeManagerEvent extends Event {
   public static var THEME_CHANGE :String = "themeChange";

   public function ThemeManagerEvent( type :String, target :Object,
      oldTheme :ITheme, newTheme :ITheme ) {
      super( type, target );
      m_oldTheme = oldTheme;
      m_newTheme = newTheme;
   }

   public function get oldTheme() :ITheme {
      return m_oldTheme;
   }

   public function get newTheme() :ITheme {
      return m_newTheme;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "oldTheme: " + m_oldTheme,
         "newTheme: " + m_newTheme
      ] );
   }

   private var m_oldTheme :ITheme;
   private var m_newTheme :ITheme;
}