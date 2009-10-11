import at.klickverbot.core.CoreObject;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.ThemeManager;
import at.klickverbot.ui.mouse.IMcCreator;

class at.klickverbot.ui.mouse.ThemeMcCreator extends CoreObject
   implements IMcCreator {

   /**
    * Constructor.
    */
   public function ThemeMcCreator( clipId :ClipId ) {
      m_clipId = clipId;
   }

   public function createClip( target :MovieClip, name :String, depth :Number ) :MovieClip {
      return ThemeManager.getInstance().getTheme().getClipFactory().createClipById(
         m_clipId, target, name, depth );
   }

   public function getClipId() :ClipId {
      return m_clipId;
   }

   public function setClipId( newClipId :ClipId ) :Void {
      m_clipId = newClipId;
   }

   private var m_clipId :ClipId;
}
