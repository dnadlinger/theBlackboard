import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.model.EntryChangeEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.themed.Static;

class at.klickverbot.theBlackboard.view.EntryTooltip extends Static {
   public function EntryTooltip( entry :Entry ) {
      super( AppClipId.ENTRY_TOOLTIP );
      m_entry = entry;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      m_captionField =
         TextField( getChild( ContainerElement.ENTRY_TOOLTIP_CAPTION, true ) );
      if ( m_captionField == null ) {
         super.destroy();
         return false;
      }

      m_authorField =
         TextField( getChild( ContainerElement.ENTRY_TOOLTIP_AUTHOR, true ) );
      if ( m_authorField == null ) {
         super.destroy();
         return false;
      }

      updateFields();

      return true;
   }

   public function get entry() :Entry {
      return m_entry;
   }

   public function set entry( to :Entry ) :Void {
      if ( m_entry != null ) {
         m_entry.removeEventListener( EntryChangeEvent.CAPTION, this, updateFields );
         m_entry.removeEventListener( EntryChangeEvent.AUTHOR, this, updateFields );
      }

      m_entry = to;

      if ( m_entry != null ) {
         m_entry.addEventListener( EntryChangeEvent.CAPTION, this, updateFields );
         m_entry.addEventListener( EntryChangeEvent.AUTHOR, this, updateFields );
      }
   }

   private function updateFields() :Void {
      if ( !m_onStage ) {
         return;
      }

      if ( m_entry == null ) {
         m_captionField.text = "";
         m_authorField.text = "";
      } else {
         m_captionField.text = m_entry.caption;
         m_authorField.text = m_entry.author;
      }
   }

   private var m_entry :Entry;

   private var m_captionField :TextField;
   private var m_authorField :TextField;
}
