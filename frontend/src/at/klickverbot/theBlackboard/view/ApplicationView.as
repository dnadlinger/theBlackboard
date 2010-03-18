import at.klickverbot.data.List;
import at.klickverbot.debug.Logger;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.CollectionEvent;
import at.klickverbot.event.events.ThemeEvent;
import at.klickverbot.event.events.ThemeManagerEvent;
import at.klickverbot.theBlackboard.Application;
import at.klickverbot.theBlackboard.model.ApplicationModel;
import at.klickverbot.theBlackboard.model.ApplicationModelChangeEvent;
import at.klickverbot.theBlackboard.view.EntriesView;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.Pointer;
import at.klickverbot.theme.SizeConstraints;
import at.klickverbot.theme.ThemeManager;
import at.klickverbot.theme.XmlTheme;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.mouse.PointerManager;
import at.klickverbot.ui.mouse.ThemeMcCreator;
import at.klickverbot.ui.tooltip.TooltipManager;
import at.klickverbot.util.Delegate;
import at.klickverbot.util.IStageListener;

class at.klickverbot.theBlackboard.view.ApplicationView extends EventDispatcher {
   /**
    * Constructor.
    */
   public function ApplicationView( model :ApplicationModel, containerClip :MovieClip ) {
      m_model = model;
      m_containerClip = containerClip;

      // Postpone initialization until the configuration has been loaded.
      model.addEventListener( ApplicationModelChangeEvent.CONFIGURATION, this, init );

      model.serviceErrors.addEventListener( CollectionEvent.CHANGE, this, handleNewServiceError );
   }

   private function init( event :ApplicationModelChangeEvent ) :Void {
      Logger.getLog( "MainView" ).info( "Configuration set, building views." );

      // Initialize the whole ui structure. We do this here and not in the
      // constructor so that the sub views don't need to take care if the
      // configuration has already been loaded...
      setupUi();

      startView();
   }

   private function setupUi() :Void {
      m_background = new Static( AppClipId.BACKGROUND );
      m_entriesView = new EntriesView( m_model.entries, m_model.configuration );
      m_entriesView.addUnhandledEventsListener( this, dispatchEvent );

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
         m_model.configuration.defaultTheme, Application.APP_NAME,
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
      if ( !m_entriesView.create( event.themeTarget ) ) {
         Logger.getLog( "MainView" ).error( "Could not create the entries view" );
      }

      // Set the default custom pointer.
      PointerManager.getInstance().setPointerContainer( event.themeTarget );
      PointerManager.getInstance().useCustomPointer( true );

      // Set the tooltip target so that the clips from the theme library can
      // be attached.
      TooltipManager.getInstance().targetClip = event.themeTarget;

      // Set up the resize handlers for fitting the view into the stage size.
      m_stageListener = new IStageListener();
      m_stageListener.onResize = Delegate.create( this, handleStageResize );
      Stage.addListener( m_stageListener );

      fitToStage();
   }

   private function destroyUi( event :ThemeEvent ) :Void {
      PointerManager.getInstance().useCustomPointer( false );
   }

   private function fitToStage() :Void {
      var constraints :SizeConstraints =
         ThemeManager.getInstance().getTheme().getStageSizeConstraints();
      var width :Number = constraints.limitWidth( Stage.width );
      var height :Number = constraints.limitHeight( Stage.height );
      m_background.resize( width, height );
      m_entriesView.resize( width, height );
   }

   private function handleStageResize() :Void {
      fitToStage();
   }

   private function handleNewServiceError( event :CollectionEvent ) :Void {
      // TODO: Replace this stub.
      Logger.getLog( "MainView" ).error(
         "Service failed: " + List( event.target ).getLast() );
   }

   private function handleThemeMismatch( event :ThemeEvent ) :Void {
      // TODO: Replace this stub.
      Logger.getLog( "MainView" ).error(
         "The theme is not suited for this application: " + event.target );
   }

   private static var RESIZE_REFRESH_INTERVAL :Number = 500;

   private var m_model :ApplicationModel;

   private var m_containerClip :MovieClip;
   private var m_stageListener :IStageListener;

   private var m_background :Static;
   private var m_entriesView :EntriesView;
}
