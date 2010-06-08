import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.UiEvent;
import at.klickverbot.graphics.Color;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.graphics.Tint;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.mouse.MouseoverManager;
import at.klickverbot.util.Delegate;
import at.klickverbot.util.McUtils;

class at.klickverbot.ui.components.TextFieldWrapperComponent extends EventDispatcher
   implements IUiComponent {
   /**
    * Constructor.
    */
   public function TextFieldWrapperComponent( textField :TextField ) {
      m_textField = textField;

      var depth :Number = textField._parent.getNextHighestDepth();
      m_mouseoverArea = textField._parent.createEmptyMovieClip(
         "mouseoverArea@" + depth, depth );
      McUtils.drawDummyRectangle( m_mouseoverArea );
      updateMouseoverArea();
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      return true;
   }

   public function destroy() :Void {
   }

   public function isOnStage() :Boolean {
      return true;
   }

   public function move( x :Number, y :Number ) :Void {
      m_textField._x = x;
      m_textField._y = y;
      updateMouseoverArea();
   }

   public function setPosition( newPosition :Point2D ) :Void {
      move( newPosition.x, newPosition.y );
   }

   public function getPosition() :Point2D {
      return new Point2D( m_textField._x, m_textField._y );
   }

   public function getGlobalPosition() :Point2D {
      return McUtils.localToGlobal( m_textField._parent, getPosition() );
   }

   public function getSize() :Point2D {
      return new Point2D( m_textField._width, m_textField._height );
   }

   public function resize( width :Number, height :Number ) :Void {
      m_textField._width = width;
      m_textField._height = height;
      updateMouseoverArea();
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      m_textField._width *= xScaleFactor;
      m_textField._height *= yScaleFactor;
      updateMouseoverArea();
   }

   public function setSize( size :Point2D ) :Void {
      resize( size.x, size.y );
   }

   public function fade( alpha :Number ) :Void {
      m_textField._alpha = alpha * 100;
   }

   public function getAlpha() :Number {
      return m_textField._alpha / 100;
   }

   public function tint( tint :Tint ) :Void {
      Debug.LIBRARY_LOG.warn( "Setting tint (" + tint + ") not supported for " +
         this );
   }

   public function getTint() :Tint {
      return new Tint( new Color( 1, 1, 1 ), 0 );
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

   /**
    * Converts the passed point from the global (stage) to the local coordinate
    * system.
    */
   private function globalToLocal( point :Point2D ) :Point2D {
      var flashPoint :Object = { x: point.x, y: point.y };
      m_textField.globalToLocal( flashPoint );
      return new Point2D( flashPoint[ "x" ], flashPoint[ "y" ] );
   }

   private function hasMouseoverListeners() :Boolean {
      return ( ( getListenerCount( UiEvent.MOUSE_OVER ) +
        getListenerCount( UiEvent.MOUSE_OUT ) ) > 0 );
   }

   private function registerMouseoverArea() :Void {
      MouseoverManager.getInstance().addArea(
         m_mouseoverArea,
         Delegate.create( this, handleMouseOn ),
         Delegate.create( this, handleMouseOff ),
         true
      );
   }

   private function deregisterMouseoverArea() :Void {
      MouseoverManager.getInstance().removeArea( m_mouseoverArea );
   }

   private function handleMouseOn() :Void {
      dispatchEventToSpecificListeners( new UiEvent( UiEvent.MOUSE_OVER, this ) );
   }

   private function handleMouseOff() :Void {
      dispatchEventToSpecificListeners( new UiEvent( UiEvent.MOUSE_OUT, this ) );
   }

   private function updateMouseoverArea() :Void {
      m_mouseoverArea._x = m_textField._x;
      m_mouseoverArea._y = m_textField._y;
      m_mouseoverArea._width = m_textField._width;
      m_mouseoverArea._height = m_textField._height;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "textField: " + m_textField );
   }

   private var m_textField :TextField;
   private var m_mouseoverArea :MovieClip;
}
