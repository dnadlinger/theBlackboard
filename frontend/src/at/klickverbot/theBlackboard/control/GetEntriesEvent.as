import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.Controller;
import at.klickverbot.theBlackboard.vo.EntriesSortingType;

class at.klickverbot.theBlackboard.control.GetEntriesEvent extends CairngormEvent {

   /**
    * Constructor.
    */
   public function GetEntriesEvent( sortingType :EntriesSortingType,
      startOffset :Number, entryLimit :Number, forceRefresh :Boolean ) {
      super( Controller.GET_ENTRIES );
      m_sortingType = sortingType;
      m_startOffset = startOffset;
      m_entryLimit = entryLimit;
      m_forceRefresh = forceRefresh;
   }

   public function get sortingType() :EntriesSortingType {
      return m_sortingType;
   }

   public function get startOffset() :Number {
      return m_startOffset;
   }

   public function get entryLimit() :Number {
      return m_entryLimit;
   }

   public function get forceRefresh() :Boolean {
      return m_forceRefresh;
   }

   private var m_sortingType :EntriesSortingType;
   private var m_startOffset :Number;
   private var m_entryLimit :Number;
   private var m_forceRefresh :Boolean;
}
