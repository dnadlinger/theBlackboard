import at.klickverbot.graphics.Point2D;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.view.DrawingToolbox;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Spacer;
import at.klickverbot.ui.components.drawingArea.DrawingArea;
import at.klickverbot.ui.components.themed.MultiContainer;

class at.klickverbot.theBlackboard.view.DrawEntryView
   extends CustomSizeableComponent {

   public function DrawEntryView( model :Entry, target :DrawingArea ) {
      super();

      m_model = model;
      m_drawingArea = target;

      m_drawEntryContainer = new MultiContainer( AppClipId.DRAW_ENTRY_CONTAINER );

      m_drawingAreaDummy = new Spacer( new Point2D( 1, 1 ) );
      m_drawEntryContainer.addContent(
         ContainerElement.NEW_DRARING_AREA, m_drawingAreaDummy );

      m_drawingToolbox = new DrawingToolbox( target );
      m_drawEntryContainer.addContent( ContainerElement.NEW_TOOLBOX, m_drawingToolbox );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_drawEntryContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

      m_drawingArea.setMouseDrawMode( true );

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
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_drawEntryContainer.resize( width, height );
   }

   public function getDrawingAreaPosition() :Point2D {
      return m_drawingAreaDummy.getGlobalPosition();
   }

   public function getDrawingAreaSize() :Point2D {
      return m_drawingAreaDummy.getSize();
   }

   public function commitChanges() :Void {
      m_drawingArea.setMouseDrawMode( false );
      m_model.drawing = m_drawingArea.getCurrentDrawing();
   }

   private var m_model :Entry;
   private var m_drawingArea :DrawingArea;
   private var m_drawEntryContainer :MultiContainer;
   private var m_drawingAreaDummy :Spacer;
   private var m_drawingToolbox :DrawingToolbox;
}
