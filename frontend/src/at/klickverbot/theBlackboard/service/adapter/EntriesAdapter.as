import at.klickverbot.theBlackboard.service.IEntriesService;
import at.klickverbot.theBlackboard.service.adapter.EntriesGetDetailOperation;
import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.model.EntriesSortingType;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.service.adapter.EntriesAddOperation;
import at.klickverbot.theBlackboard.service.adapter.EntriesGetAllOperation;
import at.klickverbot.theBlackboard.service.backend.IEntriesBackend;

class at.klickverbot.theBlackboard.service.adapter.EntriesAdapter
   extends CoreObject implements IEntriesService {
   /**
    * Constructor.
    */
   public function EntriesAdapter( backend :IEntriesBackend ) {
      m_backend = backend;
   }

   public function getEntryCount() :IOperation {
      // The result is already in the correct format (it is just a plain number),
      // so we just return the backend operation.
      return m_backend.getEntryCount();
   }

   public function getAllEntries( sortingType :EntriesSortingType ) :IOperation {
      return new EntriesGetAllOperation( m_backend, sortingType );
   }

   public function addEntry( entry :Entry ) :IOperation {
      return new EntriesAddOperation( m_backend, entry );
   }

   public function loadEntryDetails( entry :Entry ) :IOperation {
      return new EntriesGetDetailOperation( m_backend, entry );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "backend: " + m_backend );
   }

   private var m_backend :IEntriesBackend;
}
