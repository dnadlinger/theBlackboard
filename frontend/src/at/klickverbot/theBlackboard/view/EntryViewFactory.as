import at.klickverbot.theBlackboard.controller.EntryController;
import at.klickverbot.core.CoreObject;
import at.klickverbot.theBlackboard.view.EntryView;
import at.klickverbot.ui.components.data.IItemView;
import at.klickverbot.ui.components.data.IItemViewFactory;

class at.klickverbot.theBlackboard.view.EntryViewFactory extends CoreObject
   implements IItemViewFactory {

   public function createItemView() :IItemView {
      var view :EntryView = new EntryView();
      var controller :EntryController = new EntryController();
      controller.listenTo( view );
      return view;
   }
}
