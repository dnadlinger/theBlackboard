import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.IClipFactory;
import at.klickverbot.util.McUtils;

/**
 * A <code>IClipFactory</code> that creates the MovieClips by attaching them
 * from the library.
 */
class at.klickverbot.theme.LibraryClipFactory extends CoreObject
   implements IClipFactory {

   /**
    * Constructor.
    */
   public function LibraryClipFactory( libraryRoot :MovieClip ) {
      m_libraryRoot = libraryRoot;
   }

   /**
    * Creates the MovieClip that is specified with the clipId in the target
    * MovieClip.
    *
    * @param clipId A ClipId specifying which MovieClip to create.
    * @param target The MovieClip where the instance is created.
    * @param name The name of the created instance.
    * @param depth The depth at which the MovieClip is created in the target.
    */
   public function createClipById( clipId :ClipId, target :MovieClip,
      name :String, depth :Number ) :MovieClip {

      // This is a Flash restriction.
      Debug.assert( McUtils.isParentOf( m_libraryRoot, target ),
         "Cannot attach a clip from " + m_libraryRoot + " into " + target +
         ", because it is no child of it." );

      if ( depth == null ) {
         depth = target.getNextHighestDepth();
      }
      if ( name == null ) {
         name = clipId.getId() + "(MovieClip from library)@" + String( depth );
      }

      var newClip :MovieClip = target.attachMovie( clipId.getId(), name,
         depth );

      if ( newClip == null ) {
         Debug.LIBRARY_LOG.error( "Could not attach a clip with the library id " +
            clipId.getId() + " because it does not exist!" );
      }

      return newClip;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "root: " + m_libraryRoot
      ] );
   }

   private var m_libraryRoot :MovieClip;
}
