import at.klickverbot.core.CoreObject;

/** * The internal states of the EntriesView. */class at.klickverbot.theBlackboard.view.EntriesViewState extends CoreObject {   /**    * Constructor for enumeration.    * Private to make other instances than the public static members impossible.    */   private function EntriesViewState() {   }   public static var VIEW_ALL :EntriesViewState = new EntriesViewState();
   public static var DRAW :EntriesViewState = new EntriesViewState();
   public static var EDIT_DETAILS :EntriesViewState = new EntriesViewState();}