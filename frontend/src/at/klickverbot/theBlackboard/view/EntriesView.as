import at.klickverbot.theBlackboard.view.EditEntryDetailsView;
import at.klickverbot.event.events.Event;
import at.klickverbot.data.List;
import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.theBlackboard.view.Animations;
import at.klickverbot.theBlackboard.view.DrawEntryView;
import at.klickverbot.theBlackboard.view.EntriesViewState;
import at.klickverbot.theBlackboard.view.EntryView;
import at.klickverbot.theBlackboard.view.EntryViewFactory;
import at.klickverbot.theBlackboard.view.IDrawingAreaOverlay;
import at.klickverbot.theBlackboard.view.NavigationView;
import at.klickverbot.theBlackboard.view.NavigationViewEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.theBlackboard.vo.Configuration;
import at.klickverbot.theBlackboard.vo.Entry;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.Delay;
import at.klickverbot.ui.animation.Sequence;
import at.klickverbot.ui.components.Container;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Stack;
import at.klickverbot.ui.components.data.IItemViewFactory;
import at.klickverbot.ui.components.data.PaginatedGrid;
import at.klickverbot.ui.components.themed.MultiContainer;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.components.themed.StaticContainer;
import at.klickverbot.ui.layout.horizontalAlign.HorizontalAligns;
import at.klickverbot.ui.layout.stretching.StretchModes;
import at.klickverbot.ui.layout.verticalAlign.VerticalAligns;
import at.klickverbot.util.McUtils;

class at.klickverbot.theBlackboard.view.EntriesView extends CustomSizeableComponent {
   public function EntriesView( entries :List, configuration :Configuration ) {
      super();

      m_entries = entries;
      m_configuration = configuration;
      m_entryViewFactory = new EntryViewFactory();
      m_state = EntriesViewState.VIEW_ALL;
      m_currentOverlay = null;

      setupUi();
      m_navigation.addEventListener( NavigationViewEvent.PREVIOUS_PAGE,
         m_entryGrid, m_entryGrid.goToPreviousPage );
      m_navigation.addEventListener( NavigationViewEvent.NEXT_PAGE,
         m_entryGrid, m_entryGrid.goToNextPage );
      m_navigation.addEventListener( NavigationViewEvent.NEW_ENTRY,
         this, addNewEntry );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      // Create the main content clip containing all the scenery and the main
      // entries view. An extra clip is used to be able to pan/zoom it
      // independently from the overlay stack.
      var depth :Number = m_container.getNextHighestDepth();
      m_mainContentClip = m_container.createEmptyMovieClip(
         "mainContent@" + depth, depth );

      if ( !m_backScenery.create( m_mainContentClip ) ) {
         return false;
      }

      if ( !m_mainContainer.create( m_mainContentClip ) ) {
         return false;
      }

      if ( !m_frontScenery.create( m_mainContentClip ) ) {
         return false;
      }

      // Create the overlay container.
      if ( !m_overlayStack.create( m_container ) ) {
         return false;
      }

      // Fade in the scenery and the main container.
      Animator.getInstance().add( Animations.fadeIn( m_backScenery ) );

      // The flash effect is disabled at the moment since I cannot seem to get
      // it to look good.
      Animator.getInstance().add( new Sequence( [
         new Delay( Animations.FADE_DURATION * 0.8 ),
         Animations.fadeIn( m_mainContainer ) /*,
         new Delay( FADE_DURATION * 0.2 ),
         flash( m_mainContainer )*/
      ] ) );
      Animator.getInstance().add(
         Delay.preDelay( Animations.FADE_DURATION * 1.1, Animations.fadeIn( m_frontScenery ) ) );

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_mainContainer.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_backScenery.resize( width, height );
      m_mainContainer.resize( width, height );
      m_frontScenery.resize( width, height );
      m_overlayStack.resize( width, height );
      goToEditedEntry( false );
   }

   private function setupUi() :Void {
      // Setup the background scenery.
      m_backScenery = new Static( AppClipId.BACK_SCENERY );

      // Setup the main entry view.
      m_mainContainer = new MultiContainer( AppClipId.MAIN_CONTAINER );

      m_entriesContainer = new StaticContainer( AppClipId.ENTRIES_DISPLAY_CONTAINER );

      m_entryGrid = new PaginatedGrid( m_entries, m_entryViewFactory,
         m_configuration.drawingSize, m_configuration.drawingSize );
      m_entriesContainer.setContent( m_entryGrid );
      m_mainContainer.addContent( ContainerElement.MAIN_ENTRIES_DISPLAY,
         m_entriesContainer );

      var navContainer :Container = new Container();
      m_navigation = new NavigationView( m_entryGrid );
      navContainer.addContent( m_navigation, StretchModes.UNIFORM,
         HorizontalAligns.CENTER, VerticalAligns.MIDDLE );
      m_mainContainer.addContent( ContainerElement.MAIN_NAVIGATION,
         navContainer );

      // Setup the overlay container.
      m_overlayStack = new Stack();

      // Setup the foreground scenery.
      m_frontScenery = new Static( AppClipId.FRONT_SCENERY );
   }

   private function addNewEntry() :Void {
      m_state = EntriesViewState.DRAW;

      m_activeEntry = new Entry();
      m_entries.push( m_activeEntry );
      m_entryGrid.goToLastPage();

      var overlay :DrawEntryView = new DrawEntryView( m_activeEntry,
         EntryView( m_entryGrid.getViewForItem( m_activeEntry ) ).getDrawingArea() );
      overlay.addEventListener( Event.COMPLETE, this, editEntryDetails );
      activateOverlay( overlay );
      goToEditedEntry( true );
   }

   private function editEntryDetails() :Void {
      m_state = EntriesViewState.EDIT_DETAILS;

      var overlay :EditEntryDetailsView = new EditEntryDetailsView( m_activeEntry );
      overlay.addEventListener( Event.COMPLETE, this, saveEntry );
      activateOverlay( overlay );
      goToEditedEntry( true );
   }

   private function saveEntry() :Void {
      m_state = EntriesViewState.VIEW_ALL;

      // TODO: Find a better design approach for this
      EntryView( m_entryGrid.getViewForItem( m_activeEntry ) ).save();
      m_activeEntry = null;

      activateOverlay( null );
      goToGeneralView( true );
   }

   private function goToEditedEntry( animate :Boolean ) :Void {
      if ( m_currentOverlay != null ) {
         Debug.assertFuzzyEqual(
            m_currentOverlay.getDrawingAreaSize().x,
            m_currentOverlay.getDrawingAreaSize().y,
            "The drawing area must be a square."
          );
         var drawingSize :Number = m_currentOverlay.getDrawingAreaSize().x;
         var drawingPosition :Point2D = m_currentOverlay.getDrawingAreaPosition();

         goToEntry( drawingPosition, drawingSize, animate );
      }
   }

   private function goToEntry( targetPosition :Point2D, targetSize :Number,
      animate :Boolean ) :Void {
      // The factor the main container has to be scaled with so that a cell of
      // the entry grid it contains has the same size as the drawing area in the
      // overlay stack.
      var scaleFactor :Number =
         targetSize / m_configuration.drawingSize;

      var position :Point2D = McUtils.globalToLocal(
         m_mainContentClip, m_entryGrid.getViewForItem( m_activeEntry ).getGlobalPosition() );

      position.scale( scaleFactor );
      position.substract( targetPosition );

      Animations.zoomTo( m_mainContentClip, position, scaleFactor, animate );
   }

   private function goToGeneralView( animate :Boolean ) :Void {
      Animations.zoomTo( m_mainContentClip, new Point2D( 0, 0 ), 1, animate );
   }

   private function activateOverlay( overlay :IDrawingAreaOverlay ) :Void {
      if ( m_overlayStack.getSelectedComponent() != null ) {
         m_overlayStack.removeContent( m_overlayStack.getSelectedComponent() );
      }

      m_currentOverlay = overlay;
      if ( overlay != null ) {
         var overlayContainer :Container = new Container();
         overlayContainer.addContent( overlay, StretchModes.UNIFORM,
            HorizontalAligns.LEFT, VerticalAligns.TOP );
         m_overlayStack.addContent( overlayContainer );
      }
   }

   private var m_entries :List;
   private var m_configuration :Configuration;

   private var m_state :EntriesViewState;
   // The entry which is currently edited.
   private var m_activeEntry :Entry;
   private var m_overlayStack :Stack;
   private var m_currentOverlay :IDrawingAreaOverlay;

   private var m_mainContainer :MultiContainer;
   private var m_entriesContainer :StaticContainer;
   private var m_navigation :NavigationView;
   private var m_entryGrid :PaginatedGrid;
   private var m_entryViewFactory :IItemViewFactory;

   private var m_mainContentClip :MovieClip;
   private var m_backScenery :Static;
   private var m_frontScenery :Static;
}
