import at.klickverbot.core.CoreObject;
import at.klickverbot.data.List;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.Logger;
import at.klickverbot.event.events.CollectionEvent;
import at.klickverbot.event.events.PropertyChangeEvent;
import at.klickverbot.event.events.ThemeEvent;
import at.klickverbot.event.events.ThemeManagerEvent;
import at.klickverbot.event.events.TimerEvent;
import at.klickverbot.graphics.Color;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.graphics.Tint;
import at.klickverbot.theBlackboard.Application;
import at.klickverbot.theBlackboard.control.ActivateEntryUpdatingEvent;
import at.klickverbot.theBlackboard.control.SuspendEntryUpdatingEvent;
import at.klickverbot.theBlackboard.model.Model;
import at.klickverbot.theBlackboard.model.ModelChangeEvent;
import at.klickverbot.theBlackboard.view.DrawEntryView;
import at.klickverbot.theBlackboard.view.EditEntryDetailsView;
import at.klickverbot.theBlackboard.view.EntriesView;
import at.klickverbot.theBlackboard.view.NavigationView;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.theBlackboard.view.theme.Pointer;
import at.klickverbot.theBlackboard.vo.ApplicationState;
import at.klickverbot.theme.SizeConstraints;
import at.klickverbot.theme.ThemeManager;
import at.klickverbot.theme.XmlTheme;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.Delay;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.ui.animation.PropertyTween;
import at.klickverbot.ui.animation.Sequence;
import at.klickverbot.ui.animation.TintTween;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.Container;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.Stack;
import at.klickverbot.ui.components.themed.MultiContainer;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.components.themed.StaticContainer;
import at.klickverbot.ui.layout.horizontalAlign.HorizontalAligns;
import at.klickverbot.ui.layout.stretching.StretchModes;
import at.klickverbot.ui.layout.verticalAlign.VerticalAligns;
import at.klickverbot.ui.mouse.PointerManager;
import at.klickverbot.ui.mouse.ThemeMcCreator;
import at.klickverbot.util.Delegate;
import at.klickverbot.util.IStageListener;
import at.klickverbot.util.McUtils;
import at.klickverbot.util.Timer;

class at.klickverbot.theBlackboard.view.MainView extends CoreObject {
   /**
    * Constructor.
    */
   public function MainView( containerClip :MovieClip ) {
      m_containerClip = containerClip;

      // Postpone initialization until the configuration has been loaded.
      Model.getInstance().addEventListener( ModelChangeEvent.CONFIG, this, init );

      Model.getInstance().serviceErrors.addEventListener(
         CollectionEvent.CHANGE, this, handleNewServiceError );
   }

   private function init( event :ModelChangeEvent ) :Void {
      Logger.getLog( "MainView" ).info( "Configuration set, building views." );

      // Initialize the whole ui structure. We do this here and not in the
      // constructor that the sub views don't need to take care if the
      // configuration has already been loaded...
      setupUi();

      // Wait until the application state changes from loading and kickstart the
      // application.
      Model.getInstance().addEventListener( ModelChangeEvent.APPLICATION_STATE,
         this, handleAppStateChange );
   }

   private function setupUi() :Void {
      // Setup the scenery.
      m_background = new Static( AppClipId.BACKGROUND );
      m_backScenery = new Static( AppClipId.BACK_SCENERY );
      m_frontScenery = new Static( AppClipId.FRONT_SCENERY );

      // Setup the main container and its children (EntriesView and NavigationView).
      m_mainContainer = new MultiContainer( AppClipId.MAIN_CONTAINER );

      m_entriesContainer = new StaticContainer( AppClipId.ENTRIES_DISPLAY_CONTAINER );
      m_entriesView = new EntriesView();
      m_entriesContainer.setContent( m_entriesView );
      m_mainContainer.addContent( ContainerElement.MAIN_ENTRIES_DISPLAY,
         m_entriesContainer );

      m_navigation = new NavigationView();
      m_mainContainer.addContent( ContainerElement.MAIN_NAVIGATION,
         m_navigation );

      // Setup the overlay stack, which spans the whole screen and contains the
      // additional UI displayed when creating a new entry.
      m_overlayStack = new Stack();

      m_drawEntryViewContainer = new Container();
      m_drawEntryView = new DrawEntryView();
      m_drawEntryViewContainer.addContent( m_drawEntryView,
         StretchModes.UNIFORM, HorizontalAligns.LEFT, VerticalAligns.TOP );
      m_overlayStack.addContent( m_drawEntryViewContainer );

      m_editEntryDetailsViewContainer = new Container();
      m_editEntryDetailsView = new EditEntryDetailsView();
      m_editEntryDetailsViewContainer.addContent( m_editEntryDetailsView,
         StretchModes.UNIFORM, HorizontalAligns.LEFT, VerticalAligns.TOP );
      m_overlayStack.addContent( m_editEntryDetailsViewContainer );

      m_overlayStack.selectComponent( null );

      // Add and use the default pointer which is defined in the theme.
      PointerManager.getInstance().addPointer( Pointer.DEFAULT,
         new ThemeMcCreator( AppClipId.DEFAULT_POINTER ) );
      PointerManager.getInstance().selectPointer( Pointer.DEFAULT );
   }

   private function startView() :Void {
      // Register ThemeManager-listener for theme changes.
      ThemeManager.getInstance().addEventListener(
         ThemeManagerEvent.THEME_CHANGE, this, changeTheme );

      // Set default theme. This "starts" the whole view because of the theme
      // change listener.
      ThemeManager.getInstance().setTheme( new XmlTheme(
         Model.getInstance().config.defaultTheme, Application.APP_NAME,
         Application.APP_VERSION ) );
   }

   private function changeTheme( event :ThemeManagerEvent ) :Void {
      Logger.getLog( "MainView" ).info( "Initializing new theme: " + event.newTheme );

      if ( event.oldTheme != null ) {
         event.oldTheme.destroyTheme();
         event.oldTheme.removeEventListener( ThemeEvent.COMPLETE, this, createUi );
         event.oldTheme.removeEventListener( ThemeEvent.DESTROY, this, destroyUi );
      }

      event.newTheme.addEventListener( ThemeEvent.COMPLETE, this, createUi );
      event.newTheme.addEventListener( ThemeEvent.DESTROY, this, destroyUi );
      event.newTheme.addEventListener( ThemeEvent.THEME_MISMATCH, this, handleThemeMismatch );
      event.newTheme.initTheme( m_containerClip );
   }

   private function createUi( event :ThemeEvent ) :Void {
      Logger.getLog( "MainView" ).info(
         "Theme ready, creating it and building the ui." );

      // TODO: Report errors to user if creating the components fails.
      if ( !m_background.create( event.themeTarget ) ) {
         Logger.getLog( "MainView" ).error( "Could not create the background!" );
      }

      // Create the main container.
      var depth :Number = event.themeTarget.getNextHighestDepth();
      m_mainContentClip = event.themeTarget.createEmptyMovieClip( "mainContent@" + depth, depth );
      if ( !m_backScenery.create( m_mainContentClip ) ) {
         Logger.getLog( "MainView" ).error( "Could not create the back scenery!" );
      }
      if ( !m_mainContainer.create( m_mainContentClip ) ) {
         Logger.getLog( "MainView" ).error( "Could not create the main container!" );
      }
      if ( !m_frontScenery.create( m_mainContentClip ) ) {
         Logger.getLog( "MainView" ).error( "Could not create the front scenery!" );
      }

      // Create the overlay stack.
      if ( !m_overlayStack.create( event.themeTarget ) ) {
         Logger.getLog( "MainView" ).error( "Could not create the overlay stack!" );
      }

      // Set the default custom pointer.
      PointerManager.getInstance().setPointerContainer( event.themeTarget );
      PointerManager.getInstance().useCustomPointer( true );

      // Set up the resize handlers for fitting the view into the stage size.
      m_stageListener = new IStageListener();
      m_stageListener.onResize = Delegate.create( this, handleStageResize );
      Stage.addListener( m_stageListener );

      m_resizeTimer = new Timer( RESIZE_REFRESH_INTERVAL, 1 );
      m_resizeTimer.addEventListener( TimerEvent.TIMER, this, resetEntryUpdating );

      fitToStage();

      ( new ActivateEntryUpdatingEvent() ).dispatch();

      // Fade in the scenery and the main container;
      Animator.getInstance().add( fadeIn( m_backScenery ) );

      // The flash effect is disabled at the moment since I cannot seem to get
      // it to look good.
      Animator.getInstance().add( new Sequence( [
         new Delay( FADE_DURATION * 0.8 ),
         fadeIn( m_mainContainer )/*,
         new Delay( FADE_DURATION * 0.2 ),
         flash( m_mainContainer )*/
      ] ) );
      Animator.getInstance().add(
         Delay.preDelay( FADE_DURATION * 1.1, fadeIn( m_frontScenery ) ) );
   }

   private function fadeIn( component :IUiComponent ) :IAnimation {
      component.fade( 0 );
      return new Animation(
         new AlphaTween( component, 1 ),
         FADE_DURATION,
         TimeMappers.CUBIC
      );
   }

   private function flash( component :IUiComponent ) :IAnimation {
      return new Sequence( [
         new Animation(
            new TintTween( component, FULL_WHITE, ZERO_WHITE ),
            FADE_DURATION * 0.1,
            TimeMappers.SINE
         ),
         new Animation(
            new TintTween( component, ZERO_WHITE, FULL_WHITE ),
            FADE_DURATION * 0.6,
            TimeMappers.SINE
         )
      ] );
   }

   private function destroyUi( event :ThemeEvent ) :Void {
      PointerManager.getInstance().useCustomPointer( false );
   }

   private function goToEditedEntry( animate :Boolean ) :Void {
      // TODO: Use polymorphy here instead.
      var state :ApplicationState = Model.getInstance().applicationState;
      if ( state == ApplicationState.DRAW_ENTRY ) {
         Debug.assertFuzzyEqual(
            m_drawEntryView.getDrawingAreaSize().x,
            m_drawEntryView.getDrawingAreaSize().y,
            "The drawing area must be a square."
          );
         var drawingSize :Number = m_drawEntryView.getDrawingAreaSize().x;
         var drawingPosition :Point2D = m_drawEntryView.getDrawingAreaPosition();

         goToEntry( drawingPosition, drawingSize, animate );
      } else if ( state == ApplicationState.EDIT_ENTRY_DETAILS ) {
         Debug.assertFuzzyEqual(
            m_editEntryDetailsView.getDrawingAreaSize().x,
            m_editEntryDetailsView.getDrawingAreaSize().y,
            "The drawing area must be a square."
          );
         var drawingSize :Number = m_editEntryDetailsView.getDrawingAreaSize().x;
         var drawingPosition :Point2D = m_editEntryDetailsView.getDrawingAreaPosition();

         goToEntry( drawingPosition, drawingSize, animate );
      } else {
         // If we are not editing an entry, nothing needs to be done.
      }
   }

   private function goToEntry( targetPosition :Point2D, targetSize :Number,
      animate :Boolean ) :Void {
      // The factor the main container has to be scaled with so that a cell of
      // the entry grid it contains has the same size as the drawing area in the
      // overlay stack.
      var scaleFactor :Number =
         targetSize / Model.getInstance().config.drawingSize;

      var position :Point2D = McUtils.globalToLocal( m_mainContentClip,
         m_entriesView.getSelectedEntryPosition() );

      position.scale( scaleFactor );
      position.substract( targetPosition );

      zoomTo( position, scaleFactor, animate );
   }

   private function goToGeneralView( animate :Boolean ) :Void {
      zoomTo( new Point2D( 0, 0 ), 1, animate );
   }

   private function zoomTo( position :Point2D, scaleFactor :Number,
      animate :Boolean ) :Void {

      var duration :Number;
      if ( animate ) {
         duration = FADE_DURATION;
      } else {
         duration = 0;
      }

      var tweens :Array = [
         new PropertyTween( m_mainContentClip, "_x", -position.x ),
         new PropertyTween( m_mainContentClip, "_y", -position.y ),
         new PropertyTween( m_mainContentClip, "_xscale", scaleFactor * 100 ),
         new PropertyTween( m_mainContentClip, "_yscale", scaleFactor * 100 )
      ];

      for ( var i :Number = 0; i < tweens.length; ++i ) {
         Animator.getInstance().add(
            new Animation( tweens[ i ], duration, TimeMappers.CUBIC ) );
      }
   }

   private function fitToStage() :Void {
      var constraints :SizeConstraints =
         ThemeManager.getInstance().getTheme().getStageSizeConstraints();
      var width :Number = constraints.limitWidth( Stage.width );
      var height :Number = constraints.limitHeight( Stage.height );
      m_background.resize( width, height );
      m_backScenery.resize( width, height );
      m_mainContainer.resize( width, height );
      m_frontScenery.resize( width, height );
      m_overlayStack.resize( width, height );

      goToEditedEntry( false );
   }

   private function handleStageResize() :Void {
      if ( !m_resizeTimer.isRunning ) {
         m_entryUpdatingActiveBeforeResize = Model.getInstance().entryUpdatingActive;
         ( new SuspendEntryUpdatingEvent() ).dispatch();

         m_resizeTimer.start();
      }

      m_resizeTimer.reset();

      fitToStage();
   }

   private function resetEntryUpdating() :Void {
      if ( m_entryUpdatingActiveBeforeResize ) {
         var updatingEvent :ActivateEntryUpdatingEvent = new ActivateEntryUpdatingEvent();
         updatingEvent.dispatch();
      }
   }

   private function handleAppStateChange( event :PropertyChangeEvent ) :Void {
      if ( event.oldValue == ApplicationState.LOADING ) {
         startView();
         return;
      }

      // The correct overlay will be selected in handleZoomComplete.
      if ( event.newValue == ApplicationState.VIEW_ENTRIES ) {
         m_overlayStack.selectComponent( null );
         goToGeneralView( true );
      } else if ( event.newValue == ApplicationState.DRAW_ENTRY ) {
         m_overlayStack.selectComponent( m_drawEntryViewContainer );
         goToEditedEntry( true );
      } else if ( event.newValue == ApplicationState.EDIT_ENTRY_DETAILS ) {
         m_overlayStack.selectComponent( m_editEntryDetailsViewContainer );
         goToEditedEntry( true );
      }
   }

   private function handleNewServiceError( event :CollectionEvent ) :Void {
      // TODO: Replace this stub.
      Logger.getLog( "MainView" ).error(
         "Service failed: " + List( event.target ).getLastItem() );
   }

   private function handleThemeMismatch( event :ThemeEvent ) :Void {
      // TODO: Replace this stub.
      Logger.getLog( "MainView" ).error(
         "The theme is not suited for this application: " + event.target );
   }

   private static var RESIZE_REFRESH_INTERVAL :Number = 500;
   private static var MIN_WIDTH :Number = 400;
   private static var MIN_HEIGHT :Number = 400;

   private static var FADE_DURATION :Number = 0.7;
   private static var FULL_WHITE :Tint = new Tint( new Color( 1, 1, 1 ), 0.5 );
   private static var ZERO_WHITE :Tint = new Tint( new Color( 1, 1, 1 ), 0 );

   private var m_containerClip :MovieClip;
   private var m_stageListener :IStageListener;
   private var m_resizeTimer :Timer;
   private var m_entryUpdatingActiveBeforeResize :Boolean;

   private var m_background :Static;

   private var m_mainContentClip :MovieClip;
   private var m_backScenery :Static;
   private var m_mainContainer :MultiContainer;
   private var m_frontScenery :Static;

   private var m_entriesContainer :StaticContainer;
   private var m_entriesView :EntriesView;

   private var m_overlayStack :Stack;
   private var m_drawEntryView :DrawEntryView;
   private var m_drawEntryViewContainer :Container;
   private var m_editEntryDetailsView :EditEntryDetailsView;
   private var m_editEntryDetailsViewContainer :Container;

   private var m_navigation :NavigationView;
}
