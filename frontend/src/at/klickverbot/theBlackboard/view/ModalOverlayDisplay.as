import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.Container;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.layout.horizontalAlign.HorizontalAligns;
import at.klickverbot.ui.layout.stretching.StretchModes;
import at.klickverbot.ui.layout.verticalAlign.VerticalAligns;

class at.klickverbot.theBlackboard.view.ModalOverlayDisplay extends CustomSizeableComponent {
   public function ModalOverlayDisplay() {
      m_overlayContainer = new Container();
      m_background = new Static( AppClipId.MODAL_OVERLAY_BACKGROUND );
   }

   private function createUi() :Boolean {
      if ( !super.createUi() ) {
         return false;
      }

      if ( !m_overlayContainer.create( m_container ) ) {
         return false;
      }

      return true;
   }


   public function destroy() :Void {
      if ( m_onStage ) {
         m_overlayContainer.destroy();
      }

      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_overlayContainer.resize( width, height );
   }

   public function showOverlay( component :IUiComponent ) :Void {
      if ( m_overlayContainer.getContentCount() == 0 ) {
         m_overlayContainer.addContent( m_background );
      }

      m_overlayContainer.addContent( component, StretchModes.NONE,
         HorizontalAligns.CENTER, VerticalAligns.MIDDLE );
   }

   public function hideOverlay( component :IUiComponent ) :Void {
      m_overlayContainer.removeContent(component);

      if ( m_overlayContainer.getContentCount() == 1 ) {
         m_overlayContainer.removeContent( m_background );
      }
   }

   private var m_overlayContainer :Container;
   private var m_background :Static;
}
