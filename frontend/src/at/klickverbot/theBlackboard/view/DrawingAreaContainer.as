import at.klickverbot.drawing.CatmullRomSmoother;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LangReduceOptimizer;
import at.klickverbot.drawing.LineStyle;
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
   private static var OPTIMIZE_LOOK_AHEAD :Number = 10;
   private static var OPTIMIZE_TOLERANCE :Number = 4;
   private static var SMOOTHER_DISTANCE :Number = 7;

   private static var DEFAULT_OPTIMIZER :IOperationOptimizer =
      new LangReduceOptimizer( OPTIMIZE_LOOK_AHEAD, OPTIMIZE_TOLERANCE );
   private static var DEFAULT_SMOOTHER :IOperationOptimizer =
      new CatmullRomSmoother( SMOOTHER_DISTANCE );

   private static var DEFAULT_PEN_STYLE :LineStyle = new LineStyle( 6, 0xFFFFFF, 1 );

   private var m_drawingArea :DrawingArea;
}
