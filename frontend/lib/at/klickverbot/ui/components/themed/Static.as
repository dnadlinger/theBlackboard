import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.ITheme;
import at.klickverbot.theme.ThemeManager;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;

/**
 * A IUi component that is completely static – it only creates the theme clip
 * with the specified clipId and provides no additional interaction.
 *
 */
class at.klickverbot.ui.components.themed.Static extends McComponent
   implements IUiComponent {
   /**
    * Constructor.
    *
    * @param clipId A ClipId object containing the id of the clip that is
    *        created by this component.
    */
   public function Static( clipId :ClipId ) {
      super();
      m_clipId = clipId;
   }

   /**
    * Creates the visible part of the component in the target parent MovieClip.
    * The component can be recreated using @link{ #destroy } and this function,
    * but only one (visible) representation can exist at the same time.
    *
    * @param target The MovieClip where the component is created.
    * @param depth The depth in the MovieClip to create the component at.
    * @return If the component could be created.
    */
   public function create( target :MovieClip, depth :Number ) :Boolean {
      if( !super.create( target, depth ) ) {
         return false;
      }

      var activeTheme :ITheme = ThemeManager.getInstance().getTheme();
      var clip :MovieClip = activeTheme.getClipFactory().createClipById(
         m_clipId, m_container );

      if ( clip == null ) {
         Debug.LIBRARY_LOG.log( LogLevel.ERROR,
            "Could not create theme clip for Static: id: " + m_clipId );
         super.destroy();
         return false;
      }

      m_staticContent = clip;

      return true;
   }

   /**
    * Destroys the visible part of the component.
    * It can be recreated using @link{ #create }.
    */
   public function destroy() :Void {
      if ( m_onStage ) {
         m_staticContent.removeMovieClip();
         m_staticContent = null;
      }
      super.destroy();
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "clipId: " + m_clipId );
   }

   private var m_clipId :ClipId;
   private var m_staticContent :MovieClip;
}