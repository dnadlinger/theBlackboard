import at.klickverbot.core.CoreObject;

/** * Internal {@link at.klickverbot.theBlackboard.view.EntriesView} states. */class at.klickverbot.theBlackboard.view.EntriesViewState extends CoreObject {   /**    * Constructor for enumeration.    * Private to make other instances than the public static members impossible.    */   private function EntriesViewState() {   }
   /**
    * Viewing the overview page with all entries.
    */   public static var VIEW_ALL :EntriesViewState = new EntriesViewState();

   /**
    * Viewing close-up for a single entry.
    */
   public static var VIEW_SINGLE :EntriesViewState = new EntriesViewState();

   /**
    * Drawing a new entry.
    */
   public static var DRAW :EntriesViewState = new EntriesViewState();

   /**
    * Editing the details of a new entry.
    */
   public static var EDIT_DETAILS :EntriesViewState = new EntriesViewState();}