import at.klickverbot.theme.ClipId;

/**
 * Clip ids for the MovieClips from the theme for this application.
 * The purpose in using this class instead of just the plain strings is to
 * collect all needed MovieClips in one place to make creating a new theme from
 * scratch easier.
 *
 */
class at.klickverbot.theBlackboard.view.theme.AppClipId extends ClipId {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function AppClipId( id :String ) {
      super( id );
   }

   public static var MAIN_CONTAINER :AppClipId = new AppClipId( "mainContainer" );
   public static var ENTRIES_DISPLAY_CONTAINER :AppClipId = new AppClipId( "entriesDisplayContainer" );
   public static var DRAW_ENTRY_CONTAINER :AppClipId = new AppClipId( "drawEntryContainer" );
   public static var DRAWING_TOOLS_CONTAINER :AppClipId = new AppClipId( "drawingToolsContainer" );
   public static var EDIT_ENTRY_DETAILS_CONTAINER :AppClipId = new AppClipId( "editEntryDetailsContainer" );
   public static var ENTRY_DETAILS_FORM_CONTAINER :AppClipId = new AppClipId( "entryDetailsFormContainer" );

   public static var DEFAULT_POINTER :AppClipId = new AppClipId( "defaultPointer" );

   public static var DEFAULT_TEXT_BOX :AppClipId = new AppClipId( "defaultTextBox" );

   public static var PREVIOUS_PAGE_BUTTON :AppClipId = new AppClipId( "previousPageButton" );
   public static var NEXT_PAGE_BUTTON :AppClipId = new AppClipId( "nextPageButton" );
   public static var NEW_ENTRY_BUTTON :AppClipId = new AppClipId( "newEntryButton" );

   public static var WHITE_BUTTON :AppClipId = new AppClipId( "whiteButton" );
   public static var YELLOW_BUTTON :AppClipId = new AppClipId( "yellowButton" );
   public static var RED_BUTTON :AppClipId = new AppClipId( "redButton" );
   public static var GREEN_BUTTON :AppClipId = new AppClipId( "greenButton" );
   public static var BLUE_BUTTON :AppClipId = new AppClipId( "blueButton" );
   public static var BLACK_BUTTON :AppClipId = new AppClipId( "blackButton" );

   public static var SIZE_1_BUTTON :AppClipId = new AppClipId( "size1Button" );
   public static var SIZE_2_BUTTON :AppClipId = new AppClipId( "size2Button" );
   public static var SIZE_3_BUTTON :AppClipId = new AppClipId( "size3Button" );
   public static var SIZE_4_BUTTON :AppClipId = new AppClipId( "size4Button" );
   public static var SIZE_5_BUTTON :AppClipId = new AppClipId( "size5Button" );

   public static var UNDO_BUTTON :AppClipId = new AppClipId( "undoButton" );
   public static var REDO_BUTTON :AppClipId = new AppClipId( "redoButton" );

   public static var NEXT_STEP_BUTTON :AppClipId = new AppClipId( "nextStepButton" );
}
