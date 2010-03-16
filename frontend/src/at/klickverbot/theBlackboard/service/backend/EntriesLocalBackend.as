import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.FaultOperation;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.rpc.ResultOperation;
import at.klickverbot.theBlackboard.service.backend.IEntriesBackend;

class at.klickverbot.theBlackboard.service.backend.EntriesLocalBackend extends CoreObject
   implements IEntriesBackend {

   public function EntriesLocalBackend( name :String ) {
      m_sharedObject = SharedObject.getLocal( name );
      if ( m_sharedObject.data[ INITIALIZED ] == null ) {
         m_sharedObject.data[ ENTRIES ] = new Array();
         m_sharedObject.data[ LAST_ID ] = 0;
         m_sharedObject.data[ INITIALIZED ] = true;
      }
   }

   public function getEntryCount() :IOperation {
      return new ResultOperation( m_sharedObject.data[ ENTRIES ].length );
   }

   public function getAllIds( sortingType :String ) :IOperation {
      var entries :Array = m_sharedObject.data[ ENTRIES ];

      if ( sortingType == "newToOld" ) {
         entries.sortOn( ENTRY_TIMESTAMP, Array.DESCENDING );
      } else {
         return new FaultOperation( null, "Unknown sorting type." );
      }

      var ids :Array = new Array();
      for ( var i :Number = 0; i < entries.length; ++i ) {
         ids.push( entries[ i ][ ENTRY_ID ] );
      }

      return new ResultOperation( ids );
   }

   public function getIdsForRange( sortingType :String,
      startOffset :Number, entryCount :Number ) :IOperation {

      var entries :Array = m_sharedObject.data[ ENTRIES ];
      var endIndex :Number = startOffset + entryCount;

      if ( entries.length < endIndex ) {
         return new FaultOperation( null, "Not so many entries available." );
      }

      if ( sortingType == "newToOld" ) {
         entries.sortOn( ENTRY_TIMESTAMP, Array.DESCENDING );
      } else {
         return new FaultOperation( null, "Unknown sorting type." );
      }

      var ids :Array = new Array();
      for ( var i :Number = startOffset; i < endIndex; ++i ) {
         ids.push( entries[ i ][ ENTRY_ID ] );
      }

      return new ResultOperation( ids );
   }

   public function getEntryById( entryId :Number ) :IOperation {
      var result :Object = null;

      var entries :Array = m_sharedObject.data[ ENTRIES ];
      for ( var i :Number = 0; i < entries.length; ++i ) {
         if ( entries[ i ][ ENTRY_ID ] == entryId ) {
            result = entries[ i ];
            break;
         }
      }

      if ( result == null ) {
         return new FaultOperation( null, "The requested entry was not found." );
      } else {
         return new ResultOperation( result );
      }
   }

   public function addEntry( caption :String, author :String,
      drawingString :String ) :IOperation {

      ++m_sharedObject.data[ LAST_ID ];

      var entry :Object = new Object();
      entry[ ENTRY_ID ] = m_sharedObject.data[ LAST_ID ];
      entry[ ENTRY_CAPTION ] = caption;
      entry[ ENTRY_AUTHOR ] = author;
      entry[ ENTRY_DRAWING_STRING ] = drawingString;
      entry[ ENTRY_TIMESTAMP ] = new Date();

      m_sharedObject.data[ ENTRIES ].push( entry );
      m_sharedObject.flush();

      return new ResultOperation();
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "size: " + m_sharedObject.getSize() );
   }

   private static var ENTRIES :String = "entries";
   private static var LAST_ID :String = "lastId";
   private static var INITIALIZED :String = "initialized";

   private static var ENTRY_ID :String = "id";
   private static var ENTRY_CAPTION :String = "caption";
   private static var ENTRY_AUTHOR :String = "author";
   private static var ENTRY_DRAWING_STRING :String = "drawingString";
   private static var ENTRY_TIMESTAMP :String = "timestamp";

   private var m_sharedObject :SharedObject;
}
