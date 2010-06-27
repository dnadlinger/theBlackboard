import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.UiEvent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.mouse.ComponentPointerMapping;
import at.klickverbot.ui.mouse.IMcCreator;
import at.klickverbot.util.Delegate;

/**
 * A singleton which provides a central point for handling the system pointer
 * and custom cursors which are displayed when the mouse is hovered
 * over <code>IUiComponent</code>s.
 */
class at.klickverbot.ui.mouse.PointerManager extends CoreObject {
   /**
    * Constructor.
    *
    * The default values do not change the current (system) cursor.
    */
   private function PointerManager() {
      m_mappings = new Array();
      m_activePointers = new Array();
      m_defaultTarget = _root;

      m_useCustomPointer = false;
      m_showPointer = true;
      m_pointerSuspensionCount = 0;

      m_pointerClip = null;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of MouseManager.
    */
   public static function getInstance() :PointerManager {
      if ( m_instance == null ) {
         m_instance = new PointerManager();
      }
      return m_instance;
   }

   /**
    * Defines whether the system pointer or a custom pointer is to be used.
    * If a custom pointer shall be used, the currently selected pointer will
    * be displayed. If a custom pointer shall be used and there is none, the class
    * will fall back to the system pointer.
    *
    * @param useCustom If a custom pointer shall be used.
    * @see #selectPointer
    */
   public function useCustomPointer( useCustom :Boolean ) :Void {
      // Do we need to change something?
      if ( useCustom != m_useCustomPointer ) {
         if ( useCustom == true && ( m_activePointers.length > 0 ) ) {
            // Hide default (system) pointer.
            Mouse.hide();
            createActivePointer();
            m_useCustomPointer = true;
         }
         else {
            // Show default (system) pointer.
            Mouse.show();
            deleteActivePointer();
            m_useCustomPointer = false;
         }
      }
   }

   /**
    * @param component The component to use the custom pointer for. If null, the
    *        pointer is displayed globally (instead of the system pointer).
    * @param pointerCreator The IMcCreator used for creating the pointer on
    *        stage.
    * @param pointerTarget An optional paramter specifying the MovieClip in
    *        which the custom pointer clip should be created. This should only
    *        be needed to work around the Flash restriction that symbols from a
    *        library can only be attached inside its own SWF.
    */
   public function setPointer( component :IUiComponent,
      pointerCreator :IMcCreator, pointerTarget :MovieClip ) :Void {

      resetPointer( component );

      var mapping :ComponentPointerMapping = new ComponentPointerMapping(
         component, pointerCreator, pointerTarget );
      m_mappings.push( mapping );

      if ( component == null ) {
         // If this is a global pointer, just add it to the active pointers list.
         m_activePointers.push( mapping );

         if ( m_activePointers.length == 1 ) {
            // If there were no other active pointers, put the global pointer on
            // stage.
            createActivePointer();
         }
      } else {
         component.addEventListener( UiEvent.MOUSE_OVER, this, handleMouseOver );
         component.addEventListener( UiEvent.MOUSE_OUT, this, handleMouseOut );
      }
   }

   public function resetPointer( component :IUiComponent ) :Boolean {
      var currentMapping :ComponentPointerMapping;
      var i :Number = m_mappings.length;
      while ( currentMapping = m_mappings[ --i ] ) {
         if ( currentMapping.component == component ) {
            component.removeEventListener( UiEvent.MOUSE_OVER, this, handleMouseOver );
            component.removeEventListener( UiEvent.MOUSE_OUT, this, handleMouseOut );

            m_mappings.splice( i, 1 );

            removeFromActivePointers( component );
            return true;
         }
      }

      return false;
   }

   /**
    * Shows the active pointer (either the system pointer or a custom one).
    */
   public function showPointer() :Void {
      if ( !m_showPointer ) {
         m_showPointer = true;
         if ( m_useCustomPointer && ( m_pointerSuspensionCount == 0 ) ) {
            m_pointerClip._visible = true;
         } else {
            Mouse.show();
         }
      }
   }

   /**
    * Hides the active pointer (either the system pointer or a custom one).
    */
   public function hidePointer() :Void {
      if ( m_showPointer ) {
         m_showPointer = false;
         if ( m_useCustomPointer ) {
            m_pointerClip._visible = false;
         } else {
            Mouse.hide();
         }
      }
   }

   public function suspendCustomPointer() :Void {
      if ( m_pointerSuspensionCount == 0 ) {
         if ( m_useCustomPointer ) {
            m_pointerClip._visible = false;
         }
      }

      ++m_pointerSuspensionCount;
   }

   public function resumeCustomPointer() :Void {
      --m_pointerSuspensionCount;

      if ( m_pointerSuspensionCount == 0 ) {
         if ( m_showPointer && m_useCustomPointer ) {
            m_pointerClip._visible = true;
         }
      }
   }

   public function getDefaultPointerTarget() :MovieClip {
      return m_defaultTarget;
   }

   public function setDefaultPointerTarget( to :MovieClip ) :Void {
      m_defaultTarget = to;
   }

   /**
    * Moves the custom cursor along (is called everytime the mouse is moved).
    */
   private function onMouseMove() :Void {
      m_pointerClip._x = m_pointerClip._parent._xmouse;
      m_pointerClip._y = m_pointerClip._parent._ymouse;

      // Update the window immedeately after the mouse is moved; this gives
      // us smoother mouse movement.
      updateAfterEvent();
   }

   /**
    * Changes the cursor image when a mouse button is pressed.
    */
   private function onMouseDown() :Void {
      m_pointerClip.gotoAndPlay( "press" );
   }

   /**
    * Changes the cursor image when a mouse button is released.
    */
   private function onMouseUp() :Void {
      m_pointerClip.gotoAndPlay( "release" );
   }

   private function createActivePointer() :Void {
      Debug.assertNotEmpty( m_activePointers, "No custom pointer to create." );

      var mapping :ComponentPointerMapping = m_activePointers[ 0 ];

      var target :MovieClip = mapping.pointerTarget;

      if ( target == null ) {
         target = m_defaultTarget;
      }

      m_pointerClip = mapping.pointerCreator.createClip(
         target, "customPointer", POINTER_DEPTH );

      if ( !m_showPointer ) {
         m_pointerClip._visible = false;
      }

      m_pointerClip._x = m_pointerClip._parent._xmouse;
      m_pointerClip._y = m_pointerClip._parent._ymouse;

      m_pointerClip.onMouseDown = Delegate.create( this, onMouseDown );
      m_pointerClip.onMouseUp = Delegate.create( this, onMouseUp );
      m_pointerClip.onMouseMove = Delegate.create( this, onMouseMove );
   }

   private function deleteActivePointer() :Void {
      m_pointerClip.onMouseDown = null;
      m_pointerClip.onMouseUp = null;
      m_pointerClip.onMouseMove = null;

      m_pointerClip.removeMovieClip();
      m_pointerClip = null;
   }

   private function handleMouseOver( event :UiEvent ) :Void {
      // Find the pointer mapping for the component broadcasting the event.
      var mapping :ComponentPointerMapping = null;
      var currentMapping :ComponentPointerMapping;
      var i :Number = m_mappings.length;
      while ( currentMapping = m_mappings[ --i ] ) {
         if ( currentMapping.component == IUiComponent( event.target ) ) {
            mapping = currentMapping;
         }
      }
      Debug.assertNotNull( mapping,
         "Did not find pointer mapping for " + event.target );

      // If there is already a pointer on stage, delete it.
      if ( m_activePointers.length > 0 ) {
         deleteActivePointer();
      }

      // Create the new pointer.
      m_activePointers.unshift( mapping );
      createActivePointer();
   }

   private function handleMouseOut( event :UiEvent ) :Void {
      removeFromActivePointers( IUiComponent( event.target ) );
   }

   /**
    * Removes the pointer for the given component from the active pointer list,
    * if any and activates the first one in the list if it was the one currently
    * on stage.
    */
   private function removeFromActivePointers( component :IUiComponent ) :Void {
      var currentMapping :ComponentPointerMapping;
      var i :Number = m_activePointers.length;
      while ( currentMapping = m_activePointers[ --i ] ) {
         if ( currentMapping.component == component ) {
            if ( i == 0 ) {
               deleteActivePointer();

               m_activePointers.shift();

               if ( m_activePointers.length > 0 ) {
                  createActivePointer();
               }
            } else {
               m_activePointers.splice( i, 1 );
            }

            return;
         }
      }
   }

   private static var POINTER_DEPTH :Number = 200;

   private static var m_instance :PointerManager;

   private var m_mappings :Array;
   private var m_activePointers :Array;

   private var m_defaultTarget :MovieClip;

   private var m_useCustomPointer :Boolean;
   private var m_showPointer :Boolean;
   private var m_pointerSuspensionCount :Number;

   private var m_pointerClip :MovieClip;

   // Can't use the (cleaner) approach of registering an IMouseListener because
   // it doesn't respect updateAfterEvent(), which is essential for smooth
   // mouse movement.
   // private var m_mouseListener :IMouseListener;
}
