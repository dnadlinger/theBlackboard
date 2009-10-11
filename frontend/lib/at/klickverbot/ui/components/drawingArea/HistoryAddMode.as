class at.klickverbot.ui.components.drawingArea.HistoryAddMode {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function HistoryAddMode() {
   }

   public static var APPEND_AT_END :HistoryAddMode = new HistoryAddMode();
   public static var DISCARD_REDO :HistoryAddMode = new HistoryAddMode();

}
