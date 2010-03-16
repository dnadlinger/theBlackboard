import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.model.EntriesSortingType;
import at.klickverbot.theBlackboard.model.Entry;

interface at.klickverbot.theBlackboard.service.IEntriesService extends ICoreInterface {
   public function getEntryCount() :IOperation;
   public function getAllEntries( sortingType :EntriesSortingType ) :IOperation;
   public function addEntry( entry :Entry ) :IOperation;
   public function loadEntryDetails( entry :Entry ) :IOperation;
}
