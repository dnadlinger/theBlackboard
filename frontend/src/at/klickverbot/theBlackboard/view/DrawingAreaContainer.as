import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.BezierSmoother;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.drawing.ReducePointsOptimizer;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.GenericContainer;
import at.klickverbot.ui.components.drawingArea.DrawingArea;

class at.klickverbot.theBlackboard.view.DrawingAreaContainer extends CustomSizeableComponent {
   /**
    * Constructor.
    */
   public function DrawingAreaContainer() {
      m_wrapperContainer = new GenericContainer();

      m_drawingArea = new DrawingArea( DEFAULT_OPTIMIZER, DEFAULT_SMOOTHER );
      m_drawingArea.penStyle = DEFAULT_PEN_STYLE;

      m_wrapperContainer.addContent( m_drawingArea );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_wrapperContainer.create( m_container ) ) {
         super.destroy();
         return false;
      }

      m_drawingArea.resize( 1000, 1000 );

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_wrapperContainer.destroy();
      }

      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to resize an EntryDisplay that is not stage!" );
         return;
      }

      super.resize( width, height );
      m_wrapperContainer.resize( width, height );
   }

   public function getDrawingArea() :DrawingArea {
      return m_drawingArea;
   }

   // TODO: Make values configurable.
   private static var OPTIMIZE_MIN_DISTANCE :Number = 5;
   private static var OPTIMIZE_STRAIGHTEN :Number = 1;

   private static var DEFAULT_OPTIMIZER :IOperationOptimizer =
      new ReducePointsOptimizer( OPTIMIZE_MIN_DISTANCE, OPTIMIZE_STRAIGHTEN );
   private static var DEFAULT_SMOOTHER :IOperationOptimizer = new BezierSmoother();

   private static var DEFAULT_PEN_STYLE :LineStyle = new LineStyle( 6, 0xFFFFFF, 1 );

   private var m_drawingArea :DrawingArea;
   private var m_wrapperContainer :GenericContainer;
}
