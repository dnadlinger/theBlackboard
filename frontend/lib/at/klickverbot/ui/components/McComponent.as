import at.klickverbot.util.TypeUtils;
import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.ui.components.IUiComponent;

/**
 * Base class for all kinds of UiComponents that require a new MovieClip to be
 * created in the target (basically every component).
 *
 */
class at.klickverbot.ui.components.McComponent extends CoreObject
   implements IUiComponent {
   /**
    * Constructor.
    */
   public function McComponent() {
      // m_container is set later when create is called.
      m_container = null;
      m_onStage = false;
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      if ( depth == null ) {
         depth = target.getNextHighestDepth();
      }

      Debug.assertPositive( depth, "The target depth for a component must be positive!" );

      if ( m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to create a component that is already on stage: " + this );
         return false;
      }

      var containerName :String = TypeUtils.getTypeName( this ) +
         "(McComponent)@" + target.getNextHighestDepth();
      m_container = target.createEmptyMovieClip( containerName, depth );

      m_onStage = true;
      return true;
   }

   public function destroy() :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to destroy a component that has not been created: " + this );
         return;
      }
      m_container.removeMovieClip();
      m_container = null;

      m_onStage = false;
   }

   public function fade( alpha :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to fade a component that is not on stage: " + this );
         return;
      }

      Debug.assertInRange( 0, alpha, 1,
         "Alpha must be between 0 and 1, but is " + alpha + "!" );
      m_container._alpha = alpha * 100;
   }

   public function getAlpha() :Number {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to get the alpha of a component " +
            "that is not on stage: " + this );
         return 0;
      }

      return m_container._alpha / 100;
   }

   public function move( x :Number, y :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to move a component that is not on stage: " + this );
         return;
      }
      m_container._x = x;
      m_container._y = y;
   }

   public function setPosition( newPosition :Point2D ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to set the position of a component " +
            "that is not on stage: " + this );
         return;
      }
      move( newPosition.x, newPosition.y );
   }

   public function getPosition() :Point2D {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to get the position of a component " +
            "that is not on stage: " + this );
         return new Point2D( 0, 0 );
      }
      return new Point2D( m_container._x, m_container._y );
   }

   public function getGlobalPosition() :Point2D {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to get the global position of a " +
            "component that is not on stage: " + this );
         return new Point2D( 0, 0 );
      }

      var point :Object = new Object();
      point[ "x" ] = m_container._x;
      point[ "y" ] = m_container._y;
      m_container._parent.localToGlobal( point );

      return new Point2D( point[ "x" ], point[ "y" ] );
   }

   public function getSize() :Point2D {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to get the size of a component " +
            "that is not on stage: " + this );
         return null;
      }

      // TODO: Why is this workaround neccessary?
      var bounds :Object = m_container.getBounds( m_container._parent );

      return new Point2D( bounds[ "xMax" ] - m_container._x,
         bounds[ "yMax" ] - m_container._y );
      //return new Point2D( m_container._width, m_container._height );
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to resize a component " +
            "that is not on stage: " + this );
         return;
      }

      // Unfortunately, we have to go this little indirection, namely converting
      // into scale factors, here. If a subclass overwrites getSize() but not this
      // function and we would just assign the new width/height to m_container,
      // the result might be unexpected.
      // TODO: Is this workaround necessary anymore?
      // FIXME: Can't resize a component once its size was 0.
      var size :Point2D = getSize();
      scale( width / size.x, height / size.y );
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to scale a component " +
            "that is not on stage: " + this );
         return;
      }

      m_container._xscale *= xScaleFactor;
      m_container._yscale *= yScaleFactor;
   }

   public function setSize( size :Point2D ) :Void {
      resize( size.x, size.y );
   }

   public function isOnStage() :Boolean {
      return m_onStage;
   }

   /**
    * Converts the passed point from the global (stage) to the local coordinate
    * system.
    */
   private function globalToLocal( point :Point2D ) :Point2D {
      var tempPoint :Object = new Object();
      tempPoint[ "x" ] = point.x;
      tempPoint[ "y" ] = point.y;

      m_container.globalToLocal( tempPoint );

      return new Point2D( tempPoint[ "x" ], tempPoint[ "y" ] );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "onStage: " + m_onStage );
   }

   private var m_container :MovieClip;
   private var m_onStage :Boolean;
}