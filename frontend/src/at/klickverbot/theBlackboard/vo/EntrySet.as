import at.klickverbot.core.CoreObject;
import at.klickverbot.theBlackboard.vo.EntriesSortingType;
import at.klickverbot.theBlackboard.vo.Entry;

class at.klickverbot.theBlackboard.vo.EntrySet extends CoreObject {
   public function EntrySet( sortingType :EntriesSortingType,
      startOffset :Number, entryCount :Number, availableCount :Number,
      entryLimit :Number ) {

      m_sortingType = sortingType;
      m_startOffset = startOffset;
      m_availableCount = availableCount;
      m_entryLimit = entryLimit;

      m_entries = new Array();
      for ( var i :Number = 0; i < entryCount ; ++i ) {
         m_entries[ i ] = new Entry();
      }
   }

   /**
    * Returns the entry at the specified position relative to the first entry
    * in the set.
    *
    * @return The entry at the specified position.
    */
   public function getEntryAt( index :Number ) :Entry {
      return m_entries[ index ];
   }

   /**
    * The number of entries in the set.
    */
   public function get entryCount() :Number {
      return m_entries.length;
   }

   /**
    * The index of the first entry in the set.
    */
   public function get startOffset() :Number {
      return m_startOffset;
   }

   /**
    * The index of the last entry in the set.
    */
   public function get endIndex() :Number {
      return m_startOffset + ( m_entries.length - 1 );
   }

   /**
    * The sorting type of the set.
    */
   public function get sortingType() :EntriesSortingType {
      return m_sortingType;
   }

   /**
    * How many entries are available from the first entry in the set.
    */
   public function get availableCount() :Number {
      return m_availableCount;
   }

   // TODO: Clean up this hacky mess.
   public function get entryLimit() :Number {
      return m_entryLimit;
   }

   private var m_entries :Array;
   private var m_sortingType :EntriesSortingType;
   private var m_startOffset :Number;
   private var m_availableCount :Number;
   private var m_entryLimit :Number;
}
