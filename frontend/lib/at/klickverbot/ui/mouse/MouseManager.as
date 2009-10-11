import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.mouse.IMcCreator;
import at.klickverbot.util.Delegate;

/**
 * Class that helps dealing with multiple custom mouse pointers
 * (in form of MovieClips).
 *
 * In order to use a custom pointer, you have to do the following:
 * <ol>
 * <li>{@link #addPointer}</li>
 * <li>{@link #selectPointer}</li>
 * <li>{@link #useCustomPointer}</li>
 * </ol>
 *
 */
class at.klickverbot.ui.mouse.MouseManager extends CoreObject {

   /**
    * Constructor.
    * Initializes all the members with values that don't change the current
    * cursor.
    */
   private function MouseManager() {
      m_useCustomPointer = false;
      m_showPointer = true;
      m_currentPointer = null;
      m_pointers = new Array();

      m_pointerClip = null;
      m_pointerContainer = _root;
      m_pointerDepth = DEFAULT_DEPTH;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of MouseManager.
    */
   public static function getInstance() :MouseManager {
      if ( m_instance == null ) {
         m_instance = new MouseManager();
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
         if ( useCustom == true && m_currentPointer != null ) {
            // Hide default (system) pointer.
            Mouse.hide();
            initializeCustomPointer();
            m_useCustomPointer = true;
         }
         else {
            // Show default (system) pointer.
            Mouse.show();
            deleteCustomPointer();
            m_useCustomPointer = false;
         }
      }
   }

   /**
    * Adds a named pointer to the list.
    *
    * @param name The name the pointer will get (used with selectPointer).
    * @param libraryId The IMcCreator that creates the pointer MovieClip.
    * @see #selectPointer
    * @see #removePointer
    */
   public function addPointer( name :String, pointerCreator :IMcCreator ) :Void {
      m_pointers[ name ] = pointerCreator;
   }

   /**
    * Removes a pointer from the list.
    * Should not be needed except for if you want to clear all references to the
    * pointer creator.
    *
    * @param name The name of the pointer to remove.
    * @return If the pointer could be removed (if false, the name does not exist).
    * @see #addPointer
    */
   public function removePointer( name :String ) :Boolean {
      if ( m_pointers[ name ] != null ) {
         delete m_pointers[ name ];
         return true;
      } else {
         return false;
      }
   }

   /**
    * Selects the pointer that is displayed as custom pointer.
    *
    * @param name The name of a pointer that was added with <code>addPointer</code>.
    * @return If the pointer could be selected (if false, specified name doesn't exist).
    */
   public function selectPointer( name :String ) :Boolean {
      if ( m_pointers[ name ] != null ) {
         m_currentPointer = name;

         // If the custom pointer is active, replace it with the new one.
         if ( m_useCustomPointer ) {
            initializeCustomPointer();
         }

         return true;
      }
      else {
         return false;
      }
   }

   /**
    * Shows the active pointer (either the system pointer or a custom one).
    */
   public function showPointer() :Void {
      if ( !m_showPointer ) {
         m_showPointer = true;
         if ( m_useCustomPointer ) {
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

   /**
    * The container in which the custom pointer clip is created.
    * Defaults to _root.
    */
   public function getPointerContainer() :MovieClip {
      return m_pointerContainer;
   }

   public function setPointerContainer( container :MovieClip ) :Void {
      m_pointerContainer = container;
   }

   /**
    * The depth the pointer clip is created at.
    * The pointer clip is created in the container at the specified depth.
    */
   public function getPointerDepth() :Number {
      return m_pointerDepth;
   }

   public function setPointerDepth( depth :Number ) :Void {
      m_pointerDepth = depth;
      // If a custom pointer is currently in use ...
      if ( m_useCustomPointer ) {
         // ... move it to the new depth.
         m_pointerClip.swapDepths( depth );
      }
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

   /**
    * Helper function for spawning the currently selected custom pointer MovieClip.
    */
   private function initializeCustomPointer() :Void {
      if ( m_pointerClip != null ) {
         deleteCustomPointer();
      }
      m_pointerClip = IMcCreator( m_pointers[ m_currentPointer ] ).createClip(
         m_pointerContainer, "customPointer", m_pointerDepth );

      if ( !m_showPointer ) {
         m_pointerClip._visible = false;
      }

      m_pointerClip._x = m_pointerClip._parent._xmouse;
      m_pointerClip._y = m_pointerClip._parent._ymouse;

      m_pointerClip.onMouseDown = Delegate.create( this, onMouseDown );
      m_pointerClip.onMouseUp = Delegate.create( this, onMouseUp );
      m_pointerClip.onMouseMove = Delegate.create( this, onMouseMove );
   }

   /**
    * Helper function for deleting the currently used custom pointer MovieClip.
    */
   private function deleteCustomPointer() :Void {
      m_pointerClip.onMouseDown = null;
      m_pointerClip.onMouseUp = null;
      m_pointerClip.onMouseMove = null;

      m_pointerClip.removeMovieClip();
      m_pointerClip = null;
   }


   private static var DEFAULT_DEPTH :Number = 200;

   private static var m_instance :MouseManager;

   private var m_useCustomPointer :Boolean;
   private var m_showPointer :Boolean;

   private var m_currentPointer :String;
   private var m_pointers :Object;

   private var m_pointerClip :MovieClip;

   private var m_pointerContainer :MovieClip;
   private var m_pointerDepth :Number;

   // Can't use the (cleaner) approach of registering an IMouseListener because
   // it doesn't respect updateAfterEvent(), which is essential for smooth
   // mouse movement.
   // private var m_mouseListener :IMouseListener;
}