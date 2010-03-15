import at.klickverbot.ui.components.IUiComponent;

interface at.klickverbot.ui.components.data.IItemView extends IUiComponent {
   public function getData() :Object;
   public function setData( data :Object ) :Void;
}
