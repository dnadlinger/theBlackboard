import at.klickverbot.debug.Debug;
import at.klickverbot.event.MixinDispatcher;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.clips.DefaultButton;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.util.Delegate;

class at.klickverbot.ui.components.themed.Button extends Static
   implements IUiComponent {

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
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( buttonHack() == null ) {
         Debug.LIBRARY_LOG.error( "Button clip content expected to be of type " +
            "DefaultButton, but was: " + m_staticContent );
         super.destroy();
         return false;
      }

      var active :MovieClip = buttonHack().getActiveArea();
      if ( active == null ) {
         active = m_staticContent;
      }

      active.onPress = Delegate.create( this, onPress );
      active.onRelease = Delegate.create( this, onRelease );
      active.onReleaseOutside = Delegate.create( this, onReleaseOutside );

      if ( !m_active ) {
         buttonHack().inactiveAni();
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

   private function getMouseoverArea() :MovieClip {
   	// Only consider the active area for the hovering events.
      return buttonHack().getActiveArea();
   }

   /*
    * Handler functions that are hooked up to the active area.
    */
   private function onPress() :Void {
      if ( m_active ) {
         buttonHack.pressAni();
         dispatchEvent( new ButtonEvent( ButtonEvent.PRESS, this ) );
      }
   }

   private function onRelease() :Void {
      if ( m_active ) {
         buttonHack.releaseAni();
         dispatchEvent( new ButtonEvent( ButtonEvent.RELEASE, this ) );
      }
   }

   private function onReleaseOutside() :Void {
      m_hovering = false;

      if ( m_active ) {
         buttonHack.releaseOutsideAni();
         dispatchEvent( new ButtonEvent( ButtonEvent.RELEASE_OUTSIDE, this ) );
      }
   }

   private function buttonHack() :DefaultButton {
   	// TODO: Program against an interface instead or else this does not make sense at all.
      return DefaultButton( m_staticContent );
   }

   private var m_active :Boolean;
   private var m_hovering :Boolean;

   private var m_dispatcher :MixinDispatcher;
}
