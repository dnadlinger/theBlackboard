import at.klickverbot.core.CoreObject;
import at.klickverbot.util.McUtils;

class at.klickverbot.util.DummyClipManager extends CoreObject {
   private function DummyClipManager() {
      m_container = _root.createEmptyMovieClip( "dummyClipManager",
         100 );
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of DummyClipManager.
    */
   public static function getInstance() :DummyClipManager {
      if ( m_instance == null ) {
         m_instance = new DummyClipManager();
      }

      return m_instance;
   }

   public function createClip() :MovieClip {
      var depth :Number = m_container.getNextHighestDepth();
      var clip :MovieClip =
         m_container.createEmptyMovieClip( "dummy" + depth, depth );

      clip._visible = false;
      return clip;
   }

   public function removeClip( clip :MovieClip ) :Boolean {
      if ( McUtils.isParentOf( m_container, clip ) ) {
         clip.removeMovieClip();
         return true;
      } else {
         return false;
      }
   }

   private var m_container :MovieClip;
   private static var m_instance :DummyClipManager;
}
