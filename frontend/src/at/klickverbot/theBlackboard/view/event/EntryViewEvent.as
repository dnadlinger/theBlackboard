import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.event.events.Event;

class at.klickverbot.theBlackboard.view.event.EntryViewEvent extends Event {
	public static var LOAD_ENTRY :String = "entryViewLoadEntry";
	public static var SAVE_ENTRY :String = "entryViewSaveEntry";
	
   public function EntryViewEvent( type :String, target :Object, entry :Entry ) {
      super( type, target );
      m_entry = entry;
   }
   
   public function get entry() :Entry {
   	return m_entry;
   }
   
   private var m_entry :Entry;
}
