import at.klickverbot.theBlackboard.vo.Entry;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.Controller;

class at.klickverbot.theBlackboard.control.SaveEntryEvent extends CairngormEvent {
   public function SaveEntryEvent( entry :Entry ) {
      super( Controller.SAVE_ENTRY );
      m_entry = entry;
   }

   public function get entry() :Entry {
      return m_entry;
   }

   private var m_entry :Entry;
}
