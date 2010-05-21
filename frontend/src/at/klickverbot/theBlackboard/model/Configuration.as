import at.klickverbot.core.CoreObject;
import at.klickverbot.theBlackboard.service.ServiceLocation;

class at.klickverbot.theBlackboard.model.Configuration extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation of this abstract class.
    */
   private function Configuration() {
   }

   public function get availableThemes() :Array {
      return m_availableThemes;
   }

   public function get defaultTheme() :String {
      return m_defaultTheme;
   }

   public function get drawingSize() :Number {
      return m_drawingSize;
   }

   public function get entryPreloadLimit() :Number {
      return m_entryPreloadLimit;
   }

   public function get entryServiceLocation() :ServiceLocation {
      return m_entryServiceLocation;
   }

   public function get authServiceLocation() :ServiceLocation {
      return m_authServiceLocation;
   }

   public function get captchaAuthServiceLocation() :ServiceLocation {
      return m_captchaAuthServiceLocation;
   }

   public function get captchaAuthImageUrl() :String {
      return m_captchaAuthImageUrl;
   }

   private var m_availableThemes :Array;
   private var m_defaultTheme :String;
   private var m_drawingSize :Number;
   private var m_entryPreloadLimit :Number;
   private var m_entryServiceLocation :ServiceLocation;
   private var m_authServiceLocation :ServiceLocation;
   private var m_captchaAuthServiceLocation :ServiceLocation;
   private var m_captchaAuthImageUrl :String;
}
