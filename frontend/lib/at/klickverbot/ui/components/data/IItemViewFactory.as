import at.klickverbot.core.ICoreInterface;
import at.klickverbot.ui.components.data.IItemView;

interface at.klickverbot.ui.components.data.IItemViewFactory extends ICoreInterface {
   public function createItemView() :IItemView;
}
