import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.event.MixinDispatcher;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.event.events.Event;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.clips.DefaultButton;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.themed.Static;

class at.klickverbot.ui.components.themed.Button extends Static
   implements IUiComponent, IEventDispatcher {

   /**
    * Constructor.
    *
    * @param clipId A ClipId object containing the id of the clip that is used
    *        for displaying the button.
    */
   public function Button( clipId :ClipId ) {
      super( clipId );

      m_active = true;
      m_hovering = false;

      m_dispatcher = new MixinDispatcher();
      m_dispatcher.overwriteMethods( this );
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

      var buttonHack :DefaultButton = DefaultButton( m_staticContent );

      var active :MovieClip = buttonHack.getActiveArea();
      if ( active == null ) {
         active = m_staticContent;
      }

      var thisHack :Button = this;

      active.onRollOver = function() :Void {
         thisHack.m_hovering = true;

         if ( thisHack.m_active ) {
            buttonHack.hoverAni();
         }

         thisHack.dispatchEvent( new ButtonEvent( ButtonEvent.HOVER_ON,
            thisHack ) );
      };

      active.onRollOut = function() :Void {
         thisHack.m_hovering = false;

         if ( thisHack.m_active ) {
            buttonHack.activeAni();
         }

         thisHack.dispatchEvent( new ButtonEvent( ButtonEvent.HOVER_OFF,
            thisHack ) );
      };

      active.onPress = function() :Void {
         if ( thisHack.m_active ) {
            buttonHack.pressAni();
            thisHack.dispatchEvent( new ButtonEvent( ButtonEvent.PRESS,
               thisHack ) );
         }
      };

      active.onRelease = function() :Void {
         if ( thisHack.m_active ) {
            buttonHack.releaseAni();
            thisHack.dispatchEvent( new ButtonEvent( ButtonEvent.RELEASE,
               thisHack ) );
         }
      };

      active.onReleaseOutside = function() :Void {
         thisHack.m_hovering = false;

         if ( thisHack.m_active ) {
            buttonHack.releaseOutsideAni();
            thisHack.dispatchEvent( new ButtonEvent(
               ButtonEvent.RELEASE_OUTSIDE, thisHack ) );
         }
      };

      if ( !m_active ) {
         buttonHack.inactiveAni();
      }

      return true;
   }

   public function isActive() :Boolean {
      return m_active;
   }

   public function setActive( active :Boolean ) :Void {
      var buttonHack :DefaultButton = DefaultButton( m_staticContent );
      if ( m_onStage ) {
         if ( m_active && !active ) {
            buttonHack.inactiveAni();
         } else if ( !m_active && active ) {
            if ( m_hovering ) {
               buttonHack.hoverAni();
            } else {
               buttonHack.activeAni();
            }
         }
      }
      m_active = active;
   }

   // The event dispatcher-related methods will be overwritten by the
   // MixinDispatcher. Only here to satisfy the compiler.
   public function addEventListener( eventType :String, handlerOwner :Object,
      handler :Function ) :Void {
   }

   public function removeEventListener( eventType :String, handlerOwner :Object,
      handler :Function ) :Boolean {
      return null;
   }

   public function getListenerCount( eventType :String ) :Number {
      return null;
   }

   public function dispatchEvent( event :Event ) :Void {
   }

   private var m_active :Boolean;
   private var m_hovering :Boolean;

   private var m_dispatcher :MixinDispatcher;
}