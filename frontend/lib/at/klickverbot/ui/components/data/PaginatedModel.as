import at.klickverbot.event.EventDispatcher;
import at.klickverbot.ui.components.data.PaginatedChangeEvent;

/**
 * Helper model to be used internally in IPaginated components to help with
 * dispatching PaginatedChangeEvents.
 */
class at.klickverbot.ui.components.data.PaginatedModel extends EventDispatcher {
   public function PaginatedModel( currentPage :Number, pageCount :Number ) {
      m_currentPage = currentPage;
      m_pageCount = pageCount;
   }

   public function get currentPage() :Number {
      return m_currentPage;
   }

   public function set currentPage( to :Number ) :Void {
      var oldValue :Number = m_currentPage;
      if ( oldValue != to ) {
         m_currentPage = to;
         dispatchEvent( new PaginatedChangeEvent(
            PaginatedChangeEvent.CURRENT_PAGE, this, oldValue, to ) );
      }
   }

   public function get pageCount() :Number {
      return m_pageCount;
   }

   public function set pageCount( to :Number ) :Void {
      var oldValue :Number = m_pageCount;
      if ( oldValue != to ) {
         m_pageCount = to;
         dispatchEvent( new PaginatedChangeEvent(
            PaginatedChangeEvent.PAGE_COUNT, this, oldValue, to ) );
      }
   }

   private var m_pageCount :Number;
   private var m_currentPage :Number;
}
