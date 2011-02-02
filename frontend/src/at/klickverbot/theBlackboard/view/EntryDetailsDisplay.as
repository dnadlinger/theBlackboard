import at.klickverbot.util.NumberUtils;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.model.EntryChangeEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.themed.Static;

class at.klickverbot.theBlackboard.view.EntryDetailsDisplay extends Static {
   public function EntryDetailsDisplay( entry :Entry ) {
      super( AppClipId.ENTRY_DETAILS_DISPLAY );
      m_entry = entry;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      m_captionField =
         TextField( getChild( ContainerElement.DETAILS_DISPLAY_CAPTION, true ) );
      if ( m_captionField == null ) {
         super.destroy();
         return false;
      }

      m_authorField =
         TextField( getChild( ContainerElement.DETAILS_DISPLAY_AUTHOR, true ) );
      if ( m_authorField == null ) {
         super.destroy();
         return false;
      }

      m_timestampField =
         TextField( getChild( ContainerElement.DETAILS_DISPLAY_TIMESTAMP, true ) );
      if ( m_timestampField == null ) {
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
         m_entry.removeEventListener( EntryChangeEvent.TIMESTAMP, this, updateFields );
      }

      m_entry = to;

      if ( m_entry != null ) {
         m_entry.addEventListener( EntryChangeEvent.CAPTION, this, updateFields );
         m_entry.addEventListener( EntryChangeEvent.AUTHOR, this, updateFields );
         m_entry.addEventListener( EntryChangeEvent.TIMESTAMP, this, updateFields );
      }
   }

   private function updateFields() :Void {
      if ( !m_onStage ) {
         return;
      }

      if ( m_entry == null ) {
         m_captionField.text = "";
         m_authorField.text = "";
         m_timestampField.text = "";
      } else {
         m_captionField.text = m_entry.caption;
         m_authorField.text = m_entry.author;

         with ( m_entry.timestamp ) {
            m_timestampField.text =
               NumberUtils.numberToString( getDate(), 2 ) + "." +
               NumberUtils.numberToString( getMonth() + 1, 2 ) + "." +
               getFullYear() + ", " +
               NumberUtils.numberToString( getHours(), 2 ) + ":" +
               NumberUtils.numberToString( getMinutes(), 2 );
         }
      }
   }

   private var m_entry :Entry;

   private var m_captionField :TextField;
   private var m_authorField :TextField;
   private var m_timestampField :TextField;
}
