import at.klickverbot.core.ICoreInterface;
import at.klickverbot.ui.components.IUiComponent;

interface at.klickverbot.ui.layout.verticalAlign.IVerticalAlign extends ICoreInterface {
   public function move( component :IUiComponent, targetHeight :Number ) :Void;
}
