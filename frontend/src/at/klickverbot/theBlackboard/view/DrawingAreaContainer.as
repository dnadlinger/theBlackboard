import at.klickverbot.drawing.BezierSmoothOptimizer;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.drawing.SimpleReduceOptimizer;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.ui.components.drawingArea.DrawingArea;

class at.klickverbot.theBlackboard.view.DrawingAreaContainer extends McComponent {
   /**
    * Constructor.
    */
   public function DrawingAreaContainer() {
      m_drawingArea = new DrawingArea( DEFAULT_OPTIMIZER, DEFAULT_SMOOTHER );
      m_drawingArea.penStyle = DEFAULT_PEN_STYLE;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_drawingArea.create( m_container ) ) {
         super.destroy();
         return false;
      }

      m_drawingArea.resize( 1000, 1000 );

      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_drawingArea.destroy();
      }

      super.destroy();
   }

   public function getDrawingArea() :DrawingArea {
      return m_drawingArea;
   }

   // TODO: Make values configurable.
   private static var OPTIMIZE_MIN_DISTANCE :Number = 5;
   private static var OPTIMIZE_STRAIGHTEN :Number = 1;

   private static var DEFAULT_OPTIMIZER :IOperationOptimizer =
      new SimpleReduceOptimizer( OPTIMIZE_MIN_DISTANCE, OPTIMIZE_STRAIGHTEN );
   private static var DEFAULT_SMOOTHER :IOperationOptimizer = new BezierSmoothOptimizer();

   private static var DEFAULT_PEN_STYLE :LineStyle = new LineStyle( 6, 0xFFFFFF, 1 );

   private var m_drawingArea :DrawingArea;
}
