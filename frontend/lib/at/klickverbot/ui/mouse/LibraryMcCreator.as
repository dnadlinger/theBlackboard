import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.mouse.IMcCreator;

class at.klickverbot.ui.mouse.LibraryMcCreator extends CoreObject
   implements IMcCreator {

   /**
    * Constructor.
    */
   public function LibraryMcCreator( libraryId :String ) {
      m_libraryId = libraryId;
   }

   public function createClip( target :MovieClip, name :String, depth :Number ) :MovieClip {
      if ( depth == null ) {
         depth = target.getNextHighestDepth();
      }
      if ( name == null ) {
         name = m_libraryId + depth;
      }

      return target.attachMovie( m_libraryId, name, depth );
   }

   public function getLibraryId() :String {
      return m_libraryId;
   }

   public function setLibraryId( newId :String ) :Void {
      m_libraryId = newId;
   }

   private var m_libraryId :String;
}
