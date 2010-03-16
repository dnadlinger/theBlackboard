import at.klickverbot.core.CoreObject;
import at.klickverbot.theBlackboard.view.EntriesView;
import at.klickverbot.theBlackboard.view.EntryView;
import at.klickverbot.ui.components.data.IItemView;
import at.klickverbot.ui.components.data.IItemViewFactory;

class at.klickverbot.theBlackboard.view.EntryViewFactory extends CoreObject
   implements IItemViewFactory {

   /**
    * Constructor.
    */
   public function EntryViewFactory( parent :EntriesView ) {
      m_parent = parent;
   }

   public function createItemView() :IItemView {
      var view :EntryView = new EntryView();
      m_parent.registerEntryView( view );
      return view;
   }

   private var m_parent :EntriesView;
}
