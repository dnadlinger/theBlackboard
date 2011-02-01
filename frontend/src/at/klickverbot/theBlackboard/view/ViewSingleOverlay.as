import at.klickverbot.graphics.Point2D;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.view.EntryDetailsDisplay;
import at.klickverbot.theBlackboard.view.IDrawingOverlay;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Spacer;
import at.klickverbot.ui.components.themed.MultiContainer;

class at.klickverbot.theBlackboard.view.ViewSingleOverlay
   extends CustomSizeableComponent implements IDrawingOverlay {

   public function ViewSingleOverlay( model :Entry ) {
      super();

      m_model = model;

      m_drawEntryContainer = new MultiContainer( AppClipId.VIEW_SINGLE_CONTAINER );

      m_drawingAreaDummy = new Spacer( new Point2D( 1, 1 ) );
      m_drawEntryContainer.addContent(
         ContainerElement.SINGLE_DRAWING_AREA, m_drawingAreaDummy );

      m_details = new EntryDetailsDisplay( m_model );
      m_drawEntryContainer.addContent( ContainerElement.SINGLE_DETAILS, m_details );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_drawEntryContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

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

   private var m_model :Entry;
   private var m_drawEntryContainer :MultiContainer;
   private var m_drawingAreaDummy :Spacer;
   private var m_details :EntryDetailsDisplay;
}
