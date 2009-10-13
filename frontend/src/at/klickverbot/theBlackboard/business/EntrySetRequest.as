import at.klickverbot.cairngorm.business.IResponder;
import at.klickverbot.core.CoreObject;
import at.klickverbot.theBlackboard.vo.EntriesSortingType;

class at.klickverbot.theBlackboard.business.EntrySetRequest extends CoreObject {
   public function EntrySetRequest( responder :IResponder,
      sortingType :EntriesSortingType,	startOffset :Number, entryLimit :Number ) {
      m_responder = responder;
      m_sortingType = sortingType;
      m_startOffset = startOffset;
      m_entryLimit = entryLimit;
   }

   public function get responder() :IResponder {
      return m_responder;
   }
   public function set responder( to :IResponder ) :Void {
      m_responder = to;
   }

   public function get sortingType() :EntriesSortingType {
      return m_sortingType;
   }
   public function set sortingType( to :EntriesSortingType ) :Void {
      m_sortingType = to;
   }

   public function get startOffset() :Number {
      return m_startOffset;
   }
   public function set startOffset( to :Number ) :Void {
      m_startOffset = to;
   }

   public function get entryLimit() :Number {
      return m_entryLimit;
   }
   public function set entryLimit( to :Number ) :Void {
      m_entryLimit = to;
   }

   private var m_responder :IResponder;
   private var m_sortingType :EntriesSortingType;
   private var m_startOffset :Number;
   private var m_entryLimit :Number;
}