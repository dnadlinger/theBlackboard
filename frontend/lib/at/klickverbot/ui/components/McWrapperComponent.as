import at.klickverbot.core.CoreObject;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.ui.components.IUiComponent;

/**
 * Wraps a "normal" MovieClip for use in the at.klickverbot UI subsystem.
 * Should only be used for solving compability issues.
 *
 */
class at.klickverbot.ui.components.McWrapperComponent extends CoreObject
   implements IUiComponent {

   /**
    * Constructor.
    */
   public function McWrapperComponent( wrappedClip :MovieClip ) {
      m_wrapped = wrappedClip;
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      // Do nothing.
      return true;
   }

   public function destroy() :Void {
      // Do nothing.
   }

   public function isOnStage() :Boolean {
      // Is always on stage.
      return true;
   }

   public function move( x :Number, y :Number ) :Void {
      m_wrapped._x = x;
      m_wrapped._y = y;
   }

   public function setPosition( newPosition :Point2D ) :Void {
      move( newPosition.x, newPosition.y );
   }

   public function getPosition() :Point2D {
      return new Point2D( m_wrapped._x, m_wrapped._y );
   }

   public function getGlobalPosition() :Point2D {
      var point :Object = new Object();
      point[ "x" ] = m_wrapped._x;
      point[ "y" ] = m_wrapped._y;
      m_wrapped._parent.localToGlobal( point );

      return new Point2D( point[ "x" ], point[ "y" ] );
   }

   public function resize( width :Number, height :Number ) :Void {
      m_wrapped._width = width;
      m_wrapped._height = height;
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      var size :Point2D = getSize();
      resize( size.x * xScaleFactor, size.y * yScaleFactor );
   }

   public function getSize() :Point2D {
      return new Point2D( m_wrapped._width, m_wrapped._height );
   }

   public function setSize( size :Point2D ) :Void {
      resize( size.x, size.y );
   }

   public function fade( alpha :Number ) :Void {
      m_wrapped._alpha = alpha * 100;
   }

   public function getAlpha() :Number {
      return m_wrapped._alpha * 100;
   }

   private var m_wrapped :MovieClip;
}
