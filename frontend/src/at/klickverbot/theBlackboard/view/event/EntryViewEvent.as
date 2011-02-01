import at.klickverbot.event.events.Event;
import at.klickverbot.theBlackboard.model.Entry;

class at.klickverbot.theBlackboard.view.event.EntryViewEvent extends Event {
   public static var LOAD_ENTRY :String = "entryViewLoadEntry";
   public static var SAVE_ENTRY :String = "entryViewSaveEntry";
   public static var VIEW_DETAILS :String = "entryViewViewDetails";

   public function EntryViewEvent( type :String, target :Object, entry :Entry ) {
      super( type, target );
      m_entry = entry;
   }

   public function get entry() :Entry {
      return m_entry;
   }

   private var m_entry :Entry;
}
