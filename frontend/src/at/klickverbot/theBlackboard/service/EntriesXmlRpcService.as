import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.XmlRpcOperation;
import at.klickverbot.theBlackboard.service.IEntriesService;

class at.klickverbot.theBlackboard.service.EntriesXmlRpcService extends CoreObject
   implements IEntriesService {

   /**
    * Constructor.
    */
   public function EntriesXmlRpcService( url :String ) {
      m_url = url;
   }

   public function getEntryCount() :IOperation {
      return new XmlRpcOperation( m_url, OBJECT_NAME + ".getEntryCount", [] );
   }

   public function getAllIds( sortingType :String ) :IOperation {
      return new XmlRpcOperation( m_url, OBJECT_NAME + ".getAllIds",
         [ sortingType ] );
   }

   public function getIdsForRange( sortingType :String, startOffset :Number,
      entryCount :Number ) :IOperation {
      return new XmlRpcOperation( m_url, OBJECT_NAME + ".getIdsForRange",
         [ sortingType, startOffset, entryCount ] );
   }

   public function getEntryById( entryId :Number ) :IOperation {
      return new XmlRpcOperation( m_url, OBJECT_NAME + ".getEntryById", [ entryId ] );
   }

   public function addEntry( caption :String, author :String, drawingString :String ) :IOperation {
      return new XmlRpcOperation( m_url, OBJECT_NAME + ".addEntry",
         [ caption, author, drawingString ] );
   }

   private static var OBJECT_NAME :String = "entries";

   private var m_url :String;
}
