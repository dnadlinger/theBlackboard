import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.util.McUtils;

class at.klickverbot.ui.components.themed.StaticContainer extends Static
   implements IUiComponent {
   /**
    * Constructor.
    *
    * @param clipId A ClipId object containing the id of the clip that is
    *        created by this component.
    */
   public function StaticContainer( clipId :ClipId ) {
      super( clipId );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      m_dummy = m_staticContent[ "content" ];
      if ( m_dummy == null ) {
         Debug.LIBRARY_LOG.error( "Attempted to create a StaticContainer using a " +
            "clip that does not have a dummy content clip (" +	m_clipId + ")." );
         super.destroy();
         return false;
      }

      if ( m_contentComponent == null ) {
         Debug.LIBRARY_LOG.error( "No content set for " + this );
         super.destroy();
         return false;
      }

      if ( !m_contentComponent.create( m_container ) ) {
         super.destroy();
         return false;
      }
      fitContentToDummy();

      return true;
   }

   /**
    * Destroys the visible part of the component.
    * It can be recreated using @link{ #create }.
    */
   public function destroy() :Void {
      if ( m_onStage ) {
         m_contentComponent.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "Attemped to resize a " +
            "SingleContainer that is not on stage." );
         return;
      }

      var oldSize :Point2D = getSize();
      var overallXFactor :Number = width / oldSize.x;
      var overallYFactor :Number = height / oldSize.y;

      var children :Array = McUtils.getChildren( m_staticContent );
      var currentChild :MovieClip;
      var i :Number = children.length;

      while ( currentChild = children[ --i ] ) {
         currentChild._xscale *= overallXFactor;
         currentChild._yscale *= overallYFactor;
         currentChild._x *= overallXFactor;
         currentChild._y *= overallYFactor;
      }
      fitContentToDummy();
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "Attemped to scale a " +
            "SingleContainer that is not on stage." );
         return;
      }
      var size :Point2D = getSize();
      resize( size.x * xScaleFactor, size.y * yScaleFactor );
   }

   /**
    * Sets the content IUiCompontent. This is only possible if the container is
    * not currently on stage.
    *
    * @param contentComponent The IUiCompontent that is placed inside the container.
    * @return If the content could be set.
    */
   public function setContent( contentComponent :IUiComponent ) :Boolean {
      if ( m_onStage ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "Cannot set the container content" +
            "when the container is already on stage." );
         return false;
      }
      m_contentComponent = contentComponent;
      return true;
   }

   private function fitContentToDummy() :Void {
      m_contentComponent.move( m_dummy._x, m_dummy._y );
      m_contentComponent.resize( m_dummy._width, m_dummy._height );
   }

   private var m_contentComponent :IUiComponent;
   private var m_dummy :MovieClip;
}
