import at.klickverbot.core.ICoreInterface;
import at.klickverbot.rpc.IOperation;

interface at.klickverbot.theBlackboard.service.backend.IEntriesService
   extends ICoreInterface {

   public function getEntryCount() :IOperation;

   public function getAllIds( sortingType :String ) :IOperation;

   public function getIdsForRange( sortingType :String,
      startOffset :Number, entryCount :Number ) :IOperation;

   public function getEntryById( entryId :Number ) :IOperation;

   public function addEntry( caption :String, author :String,
      drawingString :String ) :IOperation;
}
