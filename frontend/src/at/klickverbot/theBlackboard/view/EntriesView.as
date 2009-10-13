import at.klickverbot.debug.Debug;
import at.klickverbot.debug.Logger;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.theBlackboard.control.GetEntriesEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.model.ModelChangeEvent;
import at.klickverbot.theBlackboard.view.EntryDisplay;
import at.klickverbot.theBlackboard.vo.ApplicationState;
import at.klickverbot.theBlackboard.vo.EntriesSortingType;
import at.klickverbot.theBlackboard.vo.Entry;
import at.klickverbot.theBlackboard.vo.EntrySet;
import at.klickverbot.ui.components.Grid;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.ui.components.Spacer;
import at.klickverbot.ui.components.Stack;
import at.klickverbot.ui.components.stretching.StretchModes;

class at.klickverbot.theBlackboard.view.EntriesView extends McComponent
   implements IUiComponent {

   public function EntriesView() {
      super();

      m_entryDisplays = new Array();

      setupUi();

      Model.getInstance().addEventListener( ModelChangeEvent.CURRENT_ENTRIES,
         this, handleEntrySetChange );
      Model.getInstance().addEventListener( ModelChangeEvent.ENTRY_UPDATING_ACTIVE,
         this, handleEntryUpdatingChange );
      Model.getInstance().addEventListener( ModelChangeEvent.APPLICATION_STATE,
         this, handleApplicationStateChange );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_gridStack.create( m_container ) ) {
         return false;
      }
      m_gridStack.resize( DEFAULT_WIDTH, DEFAULT_HEIGHT );

      updateGridCapacity();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_gridStack.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to resize an EntriesView that is not stage!" );
         return;
      }
      m_gridStack.resize( width, height );
      updateGridCapacity();
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to scale an EntriesView that is not stage!" );
         return;
      }
      resize( getSize().x * xScaleFactor, getSize().y * yScaleFactor );
   }

   /**
    * Returns the position of the EntryDisplay belonging to the selected Entry
    * in the global (stage) coordinate system.
    */
   public function getSelectedEntryPosition() :Point2D {
      var selectedEntry :Entry = Model.getInstance().selectedEntry;
      if ( selectedEntry == null ) {
         return null;
      }

      // A new entry will always be displayed in the top left corner.
      if ( selectedEntry == Model.getInstance().newEntry ) {
         return getGlobalPosition();
      }

      var selectedDisplay :EntryDisplay;
      for ( var i :Number = 0; i < m_entryDisplays.length; ++i ) {
         var currentDisplay :EntryDisplay = m_entryDisplays[ i ];
         if ( currentDisplay.getEntry() == selectedEntry ) {
            selectedDisplay = currentDisplay;
            break;
         }
      }

      if ( selectedDisplay == null ) {
         Logger.getLog( "EntriesDisplay" ).warn(
            "The EntryDisplay for the selected Entry is currently not on stage." );
         return null;
      }

      return selectedDisplay.getGlobalPosition();
   }

   private function setupUi() :Void {
      m_gridStack = new Stack();

      m_normalGrid = createGrid();
      m_gridStack.addContent( m_normalGrid );

      m_editGrid = createGrid();
      m_gridStack.addContent( m_editGrid );

      m_gridStack.selectComponent( m_normalGrid );
   }

   private function updateGridCapacity() :Void {
      if ( Model.getInstance().entryUpdatingActive ) {
         var entriesEvent :GetEntriesEvent;

         var currentEntries :EntrySet = Model.getInstance().currentEntries;
         if ( currentEntries != null ) {
            entriesEvent = new GetEntriesEvent(	currentEntries.sortingType,
               currentEntries.startOffset, m_normalGrid.getCapacity(), false );
         } else {
            entriesEvent = new GetEntriesEvent( EntriesSortingType.NEW_TO_OLD,
               0, m_normalGrid.getCapacity(), false );
         }

         entriesEvent.dispatch();
      }
   }

   private function showNormalGrid() :Void {
      m_gridStack.selectComponent( m_normalGrid );
   }

   private function showEditGrid() :Void {
      // Put the grid on stage first so we can access its capacity.
      m_gridStack.selectComponent( m_editGrid );

      // Update the grid with the currently displayed entries.
      m_editGrid.removeAllContents();

      // Add a dummy for the first cell – the NewEntryView will go there.
      m_editGrid.addContent( new Spacer( new Point2D( 1, 1 ) ) );

      var entries :EntrySet = Model.getInstance().currentEntries;
      var otherEntryCount :Number = Math.min( entries.entryCount,
         ( m_editGrid.getCapacity() - 1 ) );
      m_editGrid.suspendLayout();
      for ( var i :Number = 0; i < otherEntryCount; ++i ) {
         var display :EntryDisplay = new EntryDisplay();
         display.setEntry( entries.getEntryAt( i ) );
         m_editGrid.addContent( display, StretchModes.FILL );
      }

      m_editGrid.resumeLayout();
   }

   private function handleEntrySetChange( event :ModelChangeEvent ) :Void {
      m_normalGrid.suspendLayout();
      var newEntrySet :EntrySet = EntrySet( event.newValue );

      var oldEntryCount :Number = m_entryDisplays.length;
      var newEntryCount :Number = newEntrySet.entryCount;

      // Do we need to remove or add any EntryDisplays?
      if ( newEntryCount < oldEntryCount ) {
         for ( var i :Number = newEntryCount; i < oldEntryCount; ++i ) {
            m_normalGrid.removeContent( m_entryDisplays[ i ] );
         }
         m_entryDisplays.splice( newEntryCount );
      } else if ( oldEntryCount < newEntryCount ) {
         for ( var i :Number = oldEntryCount; i < newEntryCount; ++i ) {
            var newDisplay :EntryDisplay = new EntryDisplay();
            m_entryDisplays.push( newDisplay );
            m_normalGrid.addContent( newDisplay );
         }
      }

      for ( var i :Number = 0; i < m_entryDisplays.length; ++i ) {
         EntryDisplay( m_entryDisplays[ i ] ).setEntry( newEntrySet.getEntryAt( i ) );
      }
      m_normalGrid.resumeLayout();
   }

   private function handleEntryUpdatingChange( event :ModelChangeEvent ) :Void {
      if ( m_onStage && ( event.newValue == true ) ) {
         updateGridCapacity();
      }
   }

   private function handleApplicationStateChange( event :ModelChangeEvent ) :Void {
      if ( event.newValue == ApplicationState.VIEW_ENTRIES ) {
         showNormalGrid();
         return;
      }
      if ( event.newValue == ApplicationState.DRAW_ENTRY ) {
         showEditGrid();
         return;
      }
   }

   private function createGrid() :Grid {
      var drawingSize :Number = Model.getInstance().config.drawingSize;

      var grid :Grid = new Grid( drawingSize, drawingSize );

      // TODO: Make spacing configurable?
      grid.setColumnSpacing( GRID_CELL_SPACING );
      grid.setRowSpacing( GRID_CELL_SPACING );

      return grid;
   }

   private static var GRID_CELL_SPACING :Number = 30;

   private static var DEFAULT_WIDTH :Number = 600;
   private static var DEFAULT_HEIGHT :Number = 400;

   private static var OPTIMIZE_MIN_DISTANCE :Number = 10;
   private static var OPTIMIZE_STRAIGHTEN :Number = 1;

   private static var FADE_DURATION :Number = 0.7;

   private var m_gridStack :Stack;

   // Container for the EntryDisplays.
   private var m_normalGrid :Grid;
   private var m_entryDisplays :Array;

   // Container to show while adding a new entry.
   private var m_editGrid :Grid;
}
