import at.klickverbot.core.CoreObject;
import at.klickverbot.drawing.Drawing;

class at.klickverbot.ui.components.drawingArea.HistoryStep extends CoreObject {
   /**
    * Constructor.
    */
   public function HistoryStep( drawing :Drawing, smoothedDrawing :Drawing ) {
      m_drawing = drawing;
      m_smoothedDrawing = smoothedDrawing;
   }

   public function get drawing() :Drawing {
      return m_drawing;
   }
   public function set drawing( to :Drawing ) :Void {
      m_drawing = to;
   }
   public function get smoothedDrawing() :Drawing {
      return m_smoothedDrawing;
   }
   public function set smoothedDrawing( to :Drawing ) :Void {
      m_smoothedDrawing = to;
   }

   private var m_drawing :Drawing;
   private var m_smoothedDrawing :Drawing;
}