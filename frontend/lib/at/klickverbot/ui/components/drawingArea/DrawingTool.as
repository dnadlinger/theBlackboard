class at.klickverbot.ui.components.drawingArea.DrawingTool {
   /**
    * Private constructor. Makes other instances than the public static
    * members impossible.
    */
   private function DrawingTool() {
   }

   public static var PEN :DrawingTool = new DrawingTool();
   public static var ERASER :DrawingTool = new DrawingTool();
}
