import at.klickverbot.data.List;
import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.Drawing;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.event.events.Event;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.theBlackboard.model.Configuration;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.model.EntryChangeEvent;
import at.klickverbot.theBlackboard.view.Animations;
import at.klickverbot.theBlackboard.view.DrawEntryView;
import at.klickverbot.theBlackboard.view.EditEntryDetailsView;
import at.klickverbot.theBlackboard.view.EntriesViewState;
import at.klickverbot.theBlackboard.view.EntryView;
import at.klickverbot.theBlackboard.view.EntryViewFactory;
import at.klickverbot.theBlackboard.view.IDrawingOverlay;
import at.klickverbot.theBlackboard.view.ModalOverlayDisplay;
import at.klickverbot.theBlackboard.view.NavigationView;
import at.klickverbot.theBlackboard.view.SubmitDiscardView;
import at.klickverbot.theBlackboard.view.ViewSingleOverlay;
import at.klickverbot.theBlackboard.view.ViewSingleToolbar;
import at.klickverbot.theBlackboard.view.event.NavigationViewEvent;
import at.klickverbot.theBlackboard.view.event.SubmitDiscardEvent;
import at.klickverbot.theBlackboard.view.event.ViewSingleEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.Delay;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.ui.animation.Sequence;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.Container;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Fader;
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
   public function EntriesView( entries :List, configuration :Configuration,
      overlayDisplay :ModalOverlayDisplay ) {
      super();

      m_entries = entries;
      m_configuration = configuration;
      m_modalOverlayDisplay = overlayDisplay;

      m_entryViewFactory = new EntryViewFactory( this );
      m_state = EntriesViewState.VIEW_ALL;
      m_activeDrawView = null;
      m_activeDetailsView = null;
      m_activeDrawingOverlay = null;
      m_drawingOverlayFader = null;

      setupUi();
      m_navigation.addEventListener( NavigationViewEvent.PREVIOUS_PAGE,
         this, goToPreviousPage );
      m_navigation.addEventListener( NavigationViewEvent.NEXT_PAGE,
         this, goToNextPage );
      m_navigation.addEventListener( NavigationViewEvent.NEW_ENTRY,
         this, addNewEntry );
   }

   /**
    * Sets up event handling for a child EntryView.
    *
    * This method is called from
    * {@link at.klickverbot.theBlackboard.view.EntryViewFactory}.
    */
   public function registerEntryView( view :EntryView ) :Void {
      view.addEventListener( ButtonEvent.PRESS, this, handleDrawingAreaPress );
      view.addUnhandledEventsListener( this, dispatchEvent );
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

      if ( !m_toolbarContainer.create( m_container ) ) {
         return false;
      }

      // Fade in the scenery and the main container.
      Animator.getInstance().run( Animations.fadeIn( m_backScenery ) );

      // The flash effect is disabled at the moment since I cannot seem to get
      // it to look good.
      Animator.getInstance().run( new Sequence( [
         new Delay( Animations.FADE_DURATION * 0.8 ),
         Animations.fadeIn( m_mainContainer ) /*,
         new Delay( FADE_DURATION * 0.2 ),
         flash( m_mainContainer )*/
      ] ) );
      Animator.getInstance().run(
         Delay.preDelay( Animations.FADE_DURATION * 1.1,
         Animations.fadeIn( m_frontScenery ) ) );
      Animator.getInstance().run(
         Delay.preDelay( Animations.FADE_DURATION * 1.4,
         Animations.fadeIn( m_toolbarContainer ) ) );

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_backScenery.destroy();
         m_mainContainer.destroy();
         m_frontScenery.destroy();
         m_toolbarContainer.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      if ( m_state == EntriesViewState.DRAW ||
         m_state == EntriesViewState.VIEW_SINGLE ) {
         if ( m_drawingOverlayFader.isOnStage() ) {
            // We check here if the drawingOverlayFader is already on stage,
            // because it is not created until the animated drawEntryZoom is
            // completed.
            m_drawingOverlayFader.resize( width, height );
         }

         // Make sure that the entry is still in the correct position below the
         // DrawEntryView (it is not if the fader has been resized above).
         Animator.getInstance().run( drawingOverlayZoom( false ) );
      } else if ( m_state == EntriesViewState.EDIT_DETAILS ) {
         // Do nothing.
      } else {
         resizeMainChildren();
      }

      m_toolbarContainer.setSize( getSize() );
   }

   private function resizeMainChildren() :Void {
      m_backScenery.setSize( getSize() );
      m_mainContainer.setSize( getSize() );
      m_frontScenery.setSize( getSize() );
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
      m_mainContainer.addContent( ContainerElement.MAIN_CONTENT,
         m_entriesContainer );

      // Setup the foreground scenery.
      m_frontScenery = new Static( AppClipId.FRONT_SCENERY );

      // Setup the toolbar.
      m_toolbarContainer = new MultiContainer( AppClipId.TOOLBAR_CONTAINER );
      m_toolbarStack = new Stack();

      var navContainer :Container = new Container();
      m_navigation = new NavigationView( m_entryGrid );
      navContainer.addContent( m_navigation, StretchModes.UNIFORM,
         HorizontalAligns.CENTER, VerticalAligns.MIDDLE );
      m_toolbarStack.addContent( navContainer );

      m_toolbarContainer.addContent( ContainerElement.TOOLBAR_CONTENT,
         m_toolbarStack );
   }

   private function addNewEntry() :Void {
      m_state = EntriesViewState.DRAW;

      Debug.assertNull( m_activeEntry,
         "There was another entry active when trying to add a new entry." );

      // Create a new entry and push it to the grid.
      m_activeEntry = new Entry();
      m_activeEntry.drawing = new Drawing();
      m_entries.push( m_activeEntry );
      m_entryGrid.goToLastPage();

      // Switch to the submit/discard navigation bar.
      var navContainer :Container = new Container();

      var navigation :SubmitDiscardView = new SubmitDiscardView();
      navigation.addEventListener( SubmitDiscardEvent.SUBMIT,
         this, editEntryDetails );
      navigation.addEventListener( SubmitDiscardEvent.DISCARD,
         this, discardNewEntry );

      navContainer.addContent( navigation, StretchModes.UNIFORM,
         HorizontalAligns.CENTER, VerticalAligns.MIDDLE );
      m_toolbarStack.addContent( navContainer );
      m_toolbarStack.selectComponent( navContainer );

      // Create the drawing overlay.
      Debug.assertNull( m_activeDrawView, "There was still another " +
         "DrawEntryView active when switching to drawing mode." );
      Debug.assertNull( m_activeDrawingOverlay, "When switching to drawing " +
         "mode, there must not be another active IDrawingOverlay." );

      m_activeDrawView = new DrawEntryView( m_activeEntry,
         EntryView( m_entryGrid.getViewForItem( m_activeEntry ) ).getDrawingArea() );
      m_activeDrawingOverlay = m_activeDrawView;
      var overlayContainer :Container = new Container();
      overlayContainer.addContent( m_activeDrawView, StretchModes.UNIFORM,
         HorizontalAligns.LEFT, VerticalAligns.TOP );

      m_drawingOverlayFader = new Fader( overlayContainer );
      m_drawingOverlayFader.create( m_container );
      m_drawingOverlayFader.setSize( getSize() );
      m_drawingOverlayFader.createContent();

      // Delay showing the overlay until the zoom animation is complete.
      var zoomAnimation :IAnimation = drawingOverlayZoom( true );
      zoomAnimation.addEventListener( Event.COMPLETE,
         this, fadeInDrawingOverlay );
      m_drawingOverlayFader.fade( 0 );
      Animator.getInstance().run( zoomAnimation );
   }

   private function editEntryDetails() :Void {
      m_state = EntriesViewState.EDIT_DETAILS;

      Debug.assertNull( m_activeDetailsView, "There was still another " +
         "EditEntryDetailsView active while switching to details mode!" );
      m_activeDetailsView = new EditEntryDetailsView( m_activeEntry );
      m_activeDetailsView.addEventListener( Event.COMPLETE, this, saveEntry );

      m_activeDrawView.commitChanges();
      m_drawingOverlayFader.destroyContent( true );
      m_activeDrawingOverlay = null;
      m_activeDrawView = null;

      m_modalOverlayDisplay.showOverlay( m_activeDetailsView );
   }

   private function saveEntry() :Void {
      // When the entry has been saved to the backend successfully, return to
      // the general view.
      m_activeEntry.addEventListener( EntryChangeEvent.DIRTY,
         this, finishEditMode );

      m_modalOverlayDisplay.hideOverlay( m_activeDetailsView );
      m_activeDetailsView = null;

      // TODO: Find a better design approach for this.
      EntryView( m_entryGrid.getViewForItem( m_activeEntry ) ).save();
   }

   private function finishEditMode() :Void {
      m_activeEntry.removeEventListener( EntryChangeEvent.DIRTY,
         this, finishEditMode );

      m_toolbarStack.removeContent( m_toolbarStack.getSelectedComponent() );

      resizeMainChildren();
      m_entryGrid.goToPage( m_entryGrid.getPageForItem( m_activeEntry ) );
      m_activeEntry = null;

      Animator.getInstance().run( generalViewZoom( true ) );
      m_state = EntriesViewState.VIEW_ALL;
   }

   private function discardNewEntry() :Void {
      m_drawingOverlayFader.destroyContent( true );
      m_activeDrawView = null;
      m_activeDrawingOverlay = null;

      m_toolbarStack.removeContent( m_toolbarStack.getSelectedComponent() );
      resizeMainChildren();
      Animator.getInstance().run( generalViewZoom( true ) );

      m_activeEntry = null;
      m_entries.removeLast();

      m_state = EntriesViewState.VIEW_ALL;
   }

   private function viewSingleEntry() :Void {
      Debug.assertEqual( m_state, EntriesViewState.VIEW_ALL,
        "Must be in view all mode to trigger view single mode." );
      m_state = EntriesViewState.VIEW_SINGLE;

      Debug.assertEqual( m_entryGrid.getPageForItem( m_activeEntry ),
        m_entryGrid.getCurrentPage(), "Entry to be viewed must be on current page. " );

      // Display view single toolbar.
      var toolbarContainer :Container = new Container();

      var toolbar :ViewSingleToolbar = new ViewSingleToolbar();
      toolbar.addEventListener( ViewSingleEvent.BACK, this, finishSingleView );
      toolbarContainer.addContent( toolbar,
         StretchModes.UNIFORM, HorizontalAligns.CENTER, VerticalAligns.MIDDLE );

      m_toolbarStack.addContent( toolbarContainer );
      m_toolbarStack.selectComponent( toolbarContainer );

      // Display view single overlay.
      var overlay :ViewSingleOverlay = new ViewSingleOverlay( m_activeEntry );
      m_activeDrawingOverlay = overlay;
      var overlayContainer :Container = new Container();
      overlayContainer.addContent( overlay, StretchModes.UNIFORM,
         HorizontalAligns.LEFT, VerticalAligns.TOP );

      m_drawingOverlayFader = new Fader( overlayContainer );
      m_drawingOverlayFader.create( m_container );
      m_drawingOverlayFader.setSize( getSize() );
      m_drawingOverlayFader.createContent();

      // Delay showing the overlay until the zoom animation is complete.
      var zoomAnimation :IAnimation = drawingOverlayZoom( true );
      zoomAnimation.addEventListener( Event.COMPLETE,
         this, fadeInDrawingOverlay );
      m_drawingOverlayFader.fade( 0 );
      Animator.getInstance().run( zoomAnimation );
   }

   private function finishSingleView() :Void {
      Debug.assertEqual( m_state, EntriesViewState.VIEW_SINGLE,
        "Cannot finish view single mode if not active." );
      m_state = EntriesViewState.VIEW_ALL;
      m_activeEntry = null;

      m_drawingOverlayFader.destroyContent( true );
      m_activeDrawingOverlay = null;

      m_toolbarStack.removeContent( m_toolbarStack.getSelectedComponent() );

      Animator.getInstance().run( generalViewZoom( true ) );
   }


   private function drawingOverlayZoom( animate :Boolean ) :IAnimation {
      Debug.assertNotNull( m_activeDrawingOverlay,
         "drawingOverlayZoom requested, but no active IDrawingOverlay." );

      Debug.assertFuzzyEqual(
         m_activeDrawingOverlay.getDrawingAreaSize().x,
         m_activeDrawingOverlay.getDrawingAreaSize().y,
         "The drawing area must be a square."
       );
      var drawingSize :Number = m_activeDrawingOverlay.getDrawingAreaSize().x;
      var drawingPosition :Point2D = m_activeDrawingOverlay.getDrawingAreaPosition();

      return entryZoom( drawingPosition, drawingSize, animate );
   }

   private function entryZoom( targetPosition :Point2D, targetSize :Number,
      animate :Boolean ) :IAnimation {
      // The factor the main container has to be scaled with so that a cell of
      // the entry grid it contains has the same size as the drawing area in the
      // overlay stack.
      var scaleFactor :Number =
         targetSize / m_configuration.drawingSize;

      var position :Point2D = McUtils.globalToLocal(
         m_mainContentClip, m_entryGrid.getViewForItem( m_activeEntry ).getGlobalPosition() );

      position.scale( scaleFactor );
      position.substract( targetPosition );

      return Animations.zoomTo( m_mainContentClip, position, scaleFactor, animate );
   }

   private function generalViewZoom( animate :Boolean ) :IAnimation {
      return Animations.zoomTo( m_mainContentClip, new Point2D( 0, 0 ), 1, animate );
   }

   private function goToPreviousPage( event :NavigationViewEvent ) :Void {
      var fadeOut :Animation = new Animation( new AlphaTween( m_entryGrid, 0 ),
        Animations.FADE_DURATION, TimeMappers.CUBIC );

      fadeOut.addEventListener( Event.COMPLETE,
        m_entryGrid, m_entryGrid.goToPreviousPage );
      fadeOut.addEventListener( Event.COMPLETE, this, fadeInGrid );

      Animator.getInstance().run( fadeOut );
   }

   private function goToNextPage( event :NavigationViewEvent ) :Void {
      var fadeOut :Animation = new Animation( new AlphaTween( m_entryGrid, 0 ),
        Animations.FADE_DURATION, TimeMappers.CUBIC );

      fadeOut.addEventListener( Event.COMPLETE, m_entryGrid, m_entryGrid.goToNextPage );
      fadeOut.addEventListener( Event.COMPLETE, this, fadeInGrid );

      Animator.getInstance().run( fadeOut );
   }

   private function fadeInGrid() :Void {
      Animator.getInstance().run( new Animation( new AlphaTween( m_entryGrid, 1 ),
         Animations.FADE_DURATION, TimeMappers.CUBIC ) );
   }

   private function fadeInDrawingOverlay() :Void {
      Animator.getInstance().run( Animations.fadeIn( m_drawingOverlayFader ) );
   }

   private function handleDrawingAreaPress( event :ButtonEvent ) :Void {
      var entry :Entry = Entry( EntryView( event.target ).getData() );
      m_activeEntry = entry;
      viewSingleEntry();
   }

   private var m_entries :List;
   private var m_configuration :Configuration;

   private var m_modalOverlayDisplay :ModalOverlayDisplay;

   private var m_state :EntriesViewState;
   // The entry which is currently edited.
   private var m_activeEntry :Entry;
   private var m_drawingOverlayFader :Fader;
   private var m_activeDrawView :DrawEntryView;
   private var m_activeDetailsView :EditEntryDetailsView;
   private var m_activeDrawingOverlay :IDrawingOverlay;

   private var m_mainContainer :MultiContainer;
   private var m_entriesContainer :StaticContainer;
   private var m_entryGrid :PaginatedGrid;
   private var m_entryViewFactory :IItemViewFactory;

   private var m_toolbarContainer :MultiContainer;
   private var m_toolbarStack :Stack;
   private var m_navigation :NavigationView;

   private var m_mainContentClip :MovieClip;
   private var m_backScenery :Static;
   private var m_frontScenery :Static;
}
