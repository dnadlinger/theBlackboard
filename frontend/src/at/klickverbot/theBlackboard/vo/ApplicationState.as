class at.klickverbot.theBlackboard.vo.ApplicationState {
   /**
    * Constructor for enumeration.
    * Private to make other instances than the public static members impossible.
    */
   private function ApplicationState() {
   }

   public static var LOADING :ApplicationState = new ApplicationState();
   public static var VIEW_ENTRIES :ApplicationState = new ApplicationState();
   public static var DRAW_ENTRY :ApplicationState = new ApplicationState();
   public static var EDIT_ENTRY_DETAILS :ApplicationState = new ApplicationState();
}
