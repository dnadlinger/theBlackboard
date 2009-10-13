import at.klickverbot.drawing.Point2D;

/**
 * Provides various utils for dealing with MovieClips.
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

   static public function getChildren( parent :MovieClip ) :Object {
      var result :Object = new Object();
      for ( var name :String in parent ) {
         if ( typeof( parent[ name ] ) == "movieclip" ) {
            result[ name ] = parent[ name ];
         }
      }
      return result;
   }

   static public function localToGlobal( parent :MovieClip,
      point :Point2D ) :Point2D {
      var flashPoint :Object = { x: point.x, y: point.y };
      parent.localToGlobal( flashPoint );
      return new Point2D( flashPoint[ "x" ], flashPoint[ "y" ] );
   }

   static public function globalToLocal( parent :MovieClip,
      point :Point2D ) :Point2D {
      var flashPoint :Object = { x: point.x, y: point.y };
      parent.globalToLocal( flashPoint );
      return new Point2D( flashPoint[ "x" ], flashPoint[ "y" ] );
   }
}
