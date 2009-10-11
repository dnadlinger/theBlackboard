/**
 * Provides various utils for dealing with MovieClips.
 *
 */
class at.klickverbot.util.McUtils {
   /**
    * Tests if the given MovieClip is somewhere above the other given
    * MovieClip in the display hierachy.
    *
    * @param supposedParent The MovieClip that is supposed to be clip's
    *        "ancestor".
    * @param clip The supposed child MovieClip.
    */
   static public function isParentOf( supposedParent :MovieClip,
      clip :MovieClip ) :Boolean {
      var currentClip :MovieClip = clip;

      // _root's parent is null, so we traverse the display hierachy from
      // bottom to top until we reach _root.
      while ( currentClip != null ) {
         if ( currentClip == supposedParent ) {
            return true;
         }
         currentClip = currentClip._parent;
      }
      return false;
   }

}