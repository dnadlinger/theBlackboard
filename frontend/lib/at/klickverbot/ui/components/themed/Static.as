import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.ITheme;
import at.klickverbot.theme.ThemeManager;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;

/**
 * A IUi component that is completely static – it only creates the theme clip
 * with the specified clipId and provides no additional interaction.
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

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      var activeTheme :ITheme = ThemeManager.getInstance().getTheme();
      var clip :MovieClip = activeTheme.getClipFactory().createClipById(
         m_clipId, m_container );

      if ( clip == null ) {
         Debug.LIBRARY_LOG.error(
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

   /**
    * Looks for a child with the given name in the theme content clip and
    * returns a reference to it if it is found, null otherwise.
    *
    * @param name The instance name of the child clip to look for.
    * @param required If true, an error is logged to the library log if the
    *        clip is not found.
    * @return The child clip if one is found, null otherwise.
    */
   private function getChild( name :String, required :Boolean ) :Object {
      if ( required == undefined ) {
         required = false;
      }

      var result :MovieClip = m_staticContent[ name ];
      if ( result == null ) {
         if ( required ) {
            Debug.LIBRARY_LOG.error( "Attempted to use a theme clip for  " +
               this + " which does not have child named '" + name + "'." );
         } else if ( Debug.LEVEL > DebugLevel.NORMAL ) {
            // When in a high debug mode, log every miss, even if the requested
            // clip is not marked required.
            Debug.LIBRARY_LOG.debug( "No child named '" + name + "' found in " +
               " the theme clip for " + this + "." );
         }
      }

      return result;
   }

   /**
    * Convenice wrapper for getting a child MovieClip.
    *
    * @see #getChild.
    */
   private function getChildClip( name :String, required :Boolean ) :MovieClip {
      return MovieClip( getChild( name, required ) );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "clipId: " + m_clipId );
   }

   private var m_clipId :ClipId;
   private var m_staticContent :MovieClip;
}
