import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.view.DrawingAreaContainer;
import at.klickverbot.theBlackboard.view.DrawingToolbox;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.themed.MultiContainer;

class at.klickverbot.theBlackboard.view.DrawEntryView extends CustomSizeableComponent
   implements IUiComponent {

   public function DrawEntryView() {
      super();

      m_drawEntryContainer = new MultiContainer( AppClipId.DRAW_ENTRY_CONTAINER );

      m_drawingAreaContainer = new DrawingAreaContainer();
      m_drawEntryContainer.addContent( ContainerElement.NEW_DRARING_AREA, m_drawingAreaContainer );

      m_drawingToolbox = new DrawingToolbox( m_drawingAreaContainer.getDrawingArea() );
      m_drawEntryContainer.addContent( ContainerElement.NEW_TOOLBOX, m_drawingToolbox );
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      if ( !super.create( target, depth ) ) {
         return false;
      }

      if ( !m_drawEntryContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

      m_drawingAreaContainer.getDrawingArea().setMouseDrawMode( true );

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_drawEntryContainer.destroy();
      }

      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Logger.getLog( "DrawEntryView" ).warn(
            "Attempted to resize a component that is not stage: " + this );
         return;
      }

      super.resize( width, height );
      m_drawEntryContainer.resize( width, height );
   }

   private var m_drawEntryContainer :MultiContainer;
   private var m_drawingAreaContainer :DrawingAreaContainer;
   private var m_drawingToolbox :DrawingToolbox;
}
