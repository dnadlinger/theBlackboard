import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.UiEvent;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.graphics.Tint;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.mouse.MouseoverManager;
import at.klickverbot.util.Delegate;
import at.klickverbot.util.McUtils;
import at.klickverbot.util.NumberUtils;
import at.klickverbot.util.TypeUtils;

/**
 * Base class for all kinds of UiComponents that require a new MovieClip to be
 * created in the target (basically every component).
 *
 * It dispatches two events:
 *  - UiEvent.MOUSE_OVER when the mouse enters the area above the component.
 *  - UiEvent.MOUSE_OUT when the mouse leaves the area above the component
 *    (or the component is destroyed while the mouse is above it).
 *
 * Note that these are only dispatched to explicitely added listeners, not to
 * listeners added via addUnhandledEventsListener, because the internal handling
 * of the mouse status is fairly expensive due to Flash restrictions.
 */
class at.klickverbot.ui.components.McComponent extends EventDispatcher
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

      Debug.assertNotNull( target,
         "Target movie clip for a component must not be null!" );
      Debug.assertPositive( depth,
         "Target depth for a component must be positive, but was: " + depth );

      if ( m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to create a component that is already on stage: " + this );
         return false;
      }

      var containerName :String = TypeUtils.getTypeName( this ) +
         "(McComponent)@" + target.getNextHighestDepth() + "#" + ++m_sLastId;
      m_container = target.createEmptyMovieClip( containerName, depth );
      m_onStage = true;

      if ( !createUi() ) {
         return false;
      }

      if ( hasMouseoverListeners() ) {
         registerMouseoverArea();
      }

      return true;
   }

   private function createUi() :Boolean {
      return true;
   }

   public function destroy() :Void {
      if ( !checkOnStage( "destroy" ) ) return;

      if ( hasMouseoverListeners() ) {
         if ( MouseoverManager.getInstance().isAreaHovered( getMouseoverArea() ) ) {
            // If the pointer is above the component when it is destroyed, simulate
            // a mouse off event so that listeners do not get confused.
            handleMouseOff();
         }
         deregisterMouseoverArea();
      }

      m_container.removeMovieClip();
      m_container = null;

      m_onStage = false;
   }

   public function isOnStage() :Boolean {
      return m_onStage;
   }

   public function move( x :Number, y :Number ) :Void {
      if ( !checkOnStage( "move" ) ) return;

      m_container._x = x;
      m_container._y = y;
   }

   public function setPosition( newPosition :Point2D ) :Void {
      if ( !checkOnStage( "set the position of" ) ) return;
      move( newPosition.x, newPosition.y );
   }

   public function getPosition() :Point2D {
      if ( !checkOnStage( "get the position of" ) ) return null;
      return new Point2D( m_container._x, m_container._y );
   }

   public function getGlobalPosition() :Point2D {
      if ( !checkOnStage( "get the global position of" ) ) return null;
      return McUtils.localToGlobal( m_container._parent, getPosition() );
   }

   public function getSize() :Point2D {
      if ( !checkOnStage( "get the size of" ) ) return null;

      // Using getBounds() is necessary because our convention specifies that
      // the size of a component is always measured from its registration point
      // (origin of the coordinate system) to the lower right corner of its
      // bounding box. This also makes it necessary to resort to scaling factors
      // when handling a resize. (see resize() and scale()).
      var bounds :Object = m_container.getBounds( m_container._parent );
      var result :Point2D = new Point2D( bounds[ "xMax" ] - m_container._x,
         bounds[ "yMax" ] - m_container._y );

      // If a high debugging level is activated, warn if the result obtained via
      // getBounds() differs from the _width/_height properties. This is the
      // case if some element in the MovieClip extends beyond x==0 or y==0.
      if ( Debug.LEVEL > DebugLevel.NORMAL ) {
         var traditionalSize :Point2D =
            new Point2D( m_container._width, m_container._height );
         if ( !result.equals( traditionalSize ) ) {
            Debug.LIBRARY_LOG.debug( "Is it intended that " + this +
               " extends beyond its registration point (origin): " + result +
               " vs. " + traditionalSize + "?" );
         }
      }

      return result;
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;

      // Warn on setting zero width or height for this could lead to troubles
      // because we are using scale factors.
      if ( NumberUtils.fuzzyEquals( width, 0 ) ) {
         Debug.LIBRARY_LOG.warn( "Resizing a component to zero width can cause " +
            "unwanted behavior when resizing it back to a non-zero width: " +
            this );
      }

      if ( NumberUtils.fuzzyEquals( height, 0 ) ) {
         Debug.LIBRARY_LOG.warn( "Resizing a component to zero height can cause " +
            "unwanted behavior when resizing it back to a non-zero height: " +
            this );
      }

      // Unfortunately, we have to use scale factors to honor our convention
      // regarding the size of components (see getSize()).
      var size :Point2D = getSize();

      // Resizing the container obviuosly will not help if a subclass overwrites
      // getSize() but not this method, but we cannot do anything in that case
      // anyway.
      if ( NumberUtils.fuzzyEquals( size.x, 0 ) ) {
         Debug.LIBRARY_LOG.warn( "Trying to resize a component with width 0, " +
            "setting container _width to 1 to allow for using scale factors: " +
            this );
         m_container._width = 1;
         size = getSize();
      }

      if ( NumberUtils.fuzzyEquals( size.y, 0 ) ) {
         Debug.LIBRARY_LOG.warn( "Trying to resize a component with height 0, " +
            "setting container _height to 1 to allow for using scale factors: " +
            this );
         m_container._height = 1;
         size = getSize();
      }

      scale( width / size.x, height / size.y );
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !checkOnStage( "scale" ) ) return;

      m_container._xscale *= xScaleFactor;
      m_container._yscale *= yScaleFactor;
   }

   public function setSize( size :Point2D ) :Void {
      resize( size.x, size.y );
   }

   public function fade( alpha :Number ) :Void {
      if ( !checkOnStage( "fade" ) ) return;

      Debug.assertInRange( 0, alpha, 1,
         "Alpha must be between 0 and 1, but is " + alpha + "!" );
      m_container._alpha = alpha * 100;
   }

   public function getAlpha() :Number {
      if ( !checkOnStage( "get the alpha of" ) ) return null;

      return m_container._alpha / 100;
   }

   public function tint( tint :Tint ) :Void {
      if ( !checkOnStage( "tint" ) ) return;

      // Note: This will discard any previously set color transform.
      m_container.transform.colorTransform = tint.getColorTransform();
   }

   public function getTint() :Tint {
      if ( !checkOnStage( "get the tint of" ) ) return null;

      return Tint.fromColorTransform( m_container.transform.colorTransform );
   }

   public function addEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Void {
      var hadMouseoverListeners :Boolean = hasMouseoverListeners();

      super.addEventListener( eventType, listenerOwner, listener );

      if ( isOnStage() && ( hadMouseoverListeners != hasMouseoverListeners() ) ) {
         registerMouseoverArea();
      }
   }

   public function removeEventListener( eventType :String,
      listenerOwner :Object, listener :Function ) :Boolean {
      var hadMouseoverListeners :Boolean = hasMouseoverListeners();

      var success :Boolean =
         super.removeEventListener( eventType, listenerOwner, listener );

      if ( isOnStage() && ( hadMouseoverListeners != hasMouseoverListeners() ) ) {
         deregisterMouseoverArea();
      }

      return success;
   }

   private function checkOnStage( action :String ) :Boolean {
      if ( m_onStage ) {
         return true;
      } else {
         Debug.LIBRARY_LOG.warn( "Attempted to " + action + " a component " +
            "that is not on stage: " + this );
         return false;
      }
   }

   /**
    * Returns a MovieClip which represents the area of the component which is
    * sensitive for mouseover events.
    */
   private function getMouseoverArea() :MovieClip {
      Debug.assert( m_onStage, "getMouseOverArea() called while not on stage" );
      return m_container;
   }

   /**
    * Converts the passed point from the global (stage) to the local coordinate
    * system.
    */
   private function globalToLocal( point :Point2D ) :Point2D {
      return McUtils.globalToLocal( m_container, point );
   }

   private function hasMouseoverListeners() :Boolean {
      return ( ( getListenerCount( UiEvent.MOUSE_OVER ) +
        getListenerCount( UiEvent.MOUSE_OUT ) ) > 0 );
   }

   private function registerMouseoverArea() :Void {
      MouseoverManager.getInstance().addArea(
         getMouseoverArea(),
         Delegate.create( this, handleMouseOn ),
         Delegate.create( this, handleMouseOff )
      );
   }

   private function deregisterMouseoverArea() :Void {
      MouseoverManager.getInstance().removeArea( getMouseoverArea() );
   }

   private function handleMouseOn() :Void {
      dispatchEventToSpecificListeners( new UiEvent( UiEvent.MOUSE_OVER, this ) );
   }

   private function handleMouseOff() :Void {
      dispatchEventToSpecificListeners( new UiEvent( UiEvent.MOUSE_OUT, this ) );
   }

   private function getInstanceInfo() :Array {
      if ( m_onStage && ( Debug.LEVEL > DebugLevel.NORMAL ) ) {
         // Only add the container path if a high debug level is activated
         // since it can get pretty long.
         return super.getInstanceInfo().concat( [
            "onStage: true",
            "container: " + m_container
         ] );
      } else {
         return super.getInstanceInfo().concat( "onStage: " + m_onStage );
      }
   }

   /**
    * To circumvert a strange Flash player bug, we append a unique number to the
    * end of the names of each McComponent container clip. This variable keeps
    * track of the last used id.
    */
   private static var m_sLastId :Number = 0;

   private var m_container :MovieClip;
   private var m_onStage :Boolean;
}
