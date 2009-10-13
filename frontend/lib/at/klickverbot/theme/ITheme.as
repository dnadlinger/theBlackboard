import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.theme.IClipFactory;
import at.klickverbot.theme.LayoutRules;
import at.klickverbot.theme.SizeConstraints;

interface at.klickverbot.theme.ITheme extends IEventDispatcher {
   public function initTheme( target :MovieClip ) :Boolean;
   public function destroyTheme() :Void;

   public function getLayoutRules() :LayoutRules;
   public function getStageSizeConstraints() :SizeConstraints;
   public function getClipFactory() :IClipFactory;
}