import at.klickverbot.theBlackboard.view.FaderForComponent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.Container;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Fader;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.layout.horizontalAlign.HorizontalAligns;
import at.klickverbot.ui.layout.stretching.StretchModes;
import at.klickverbot.ui.layout.verticalAlign.VerticalAligns;

class at.klickverbot.theBlackboard.view.ModalOverlayDisplay extends CustomSizeableComponent {
   public function ModalOverlayDisplay() {
      m_fadersForContents = new Array();
      m_backgroundFader = new Fader(
         new Static( AppClipId.MODAL_OVERLAY_BACKGROUND ) );
   }

   private function createUi() :Boolean {
      if ( !super.createUi() ) {
         return false;
      }

      if ( !m_backgroundFader.create( m_container ) ) {
         return false;
      }

      return true;
   }


   public function destroy() :Void {
      if ( m_onStage ) {
         var currentMapping :FaderForComponent;
         var i :Number = m_fadersForContents.length;
         while ( currentMapping = m_fadersForContents[ --i ] ) {
            currentMapping.fader.destroy();
         }
         m_backgroundFader.destroy();
      }

      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_backgroundFader.resize( width, height );

      var currentMapping :FaderForComponent;
      var i :Number = m_fadersForContents.length;
      while ( currentMapping = m_fadersForContents[ --i ] ) {
         currentMapping.fader.resize( width, height );
      }
   }

   public function showOverlay( component :IUiComponent ) :Void {
      if ( m_fadersForContents.length == 0 ) {
         m_backgroundFader.createContent();
      }

      var container :Container = new Container();
      container.addContent( component, StretchModes.NONE,
         HorizontalAligns.CENTER, VerticalAligns.MIDDLE );
      var fader :Fader = new Fader( container );

      m_fadersForContents.push( new FaderForComponent( fader, component ) );

      fader.create( m_container );
      fader.setSize( getSize() );
      fader.createContent();
   }

   public function hideOverlay( component :IUiComponent ) :Boolean {
      var currentMapping :FaderForComponent;
      var i :Number = m_fadersForContents.length;
      while ( currentMapping = m_fadersForContents[ --i ] ) {
         if ( currentMapping.component == component ) {
            currentMapping.fader.destroyContent( true );
            m_fadersForContents.splice( i, 1 );

            if ( m_fadersForContents.length == 0 ) {
               m_backgroundFader.destroyContent();
            }

            return true;
         }
      }

      return false;
   }

   private var m_fadersForContents :Array;
   private var m_backgroundFader :Fader;
}
