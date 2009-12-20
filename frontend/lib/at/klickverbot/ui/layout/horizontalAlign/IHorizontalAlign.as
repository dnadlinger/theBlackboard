import at.klickverbot.core.ICoreInterface;
import at.klickverbot.ui.components.IUiComponent;

interface at.klickverbot.ui.layout.horizontalAlign.IHorizontalAlign extends ICoreInterface {
   public function move( component :IUiComponent, targetWidth :Number ) :Void;
}
