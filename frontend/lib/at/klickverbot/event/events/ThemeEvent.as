import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.ThemeEvent extends Event {
   public static var COMPLETE :String = "complete";
   public static var EXTERN_FAILED :String ="externFailed";
   public static var DESTROY :String = "themeDestroy";
   public static var THEME_MISMATCH :String = "themeMismatch";

   public function ThemeEvent( type :String, target :Object,
      themeTarget :MovieClip ) {
      super( type, target );
      m_themeTarget = themeTarget;
   }

   public function get themeTarget() :MovieClip {
      return m_themeTarget;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "themeTarget: " + m_themeTarget
      ] );
   }

   private var m_themeTarget :MovieClip;
}
