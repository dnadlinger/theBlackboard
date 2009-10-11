import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.Event;
import at.klickverbot.event.events.ProgressEvent;
import at.klickverbot.event.events.ThemeEvent;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.IClipFactory;
import at.klickverbot.theme.ITheme;
import at.klickverbot.theme.LayoutRules;
import at.klickverbot.theme.SizeConstraints;

class at.klickverbot.theme.SwfTheme extends EventDispatcher
   implements ITheme, IClipFactory {
   /**
    * Constructor.
    */
   public function SwfTheme( fileUrl :String, appName :String,
      appThemeVersion :Number ) {

      m_fileUrl = fileUrl;
      m_appName = appName;
      m_appThemeVersion = appThemeVersion;

      m_initialized = false;
      m_loading = false;
   }

   public function initTheme( target :MovieClip ) :Boolean {
      if ( m_initialized || m_loading ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Theme is already initialized or loading!" );
         return false;
      }

      var depth :Number = target.getNextHighestDepth();
      var name :String = String( "SwfTheme@" + depth );
      m_themeTarget = target.createEmptyMovieClip( name, depth );

      m_loader = new MovieClipLoader();
      m_loader.addListener( this );
      m_loader.loadClip( m_fileUrl, m_themeTarget );

      return true;
   }

   public function destroyTheme() :Void {
      if ( !m_initialized ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Attempted to destroy theme that is not initialized" );
         return;
      }
      dispatchEvent( new ThemeEvent( ThemeEvent.DESTROY, this, m_themeTarget ) );
      m_loader.unloadClip( m_themeTarget );

      m_clipFactory = null;
      m_themeTarget = null;

      m_initialized = false;
   }

   public function createClipById( clipId :ClipId, target :MovieClip,
      name :String, depth :Number ) :MovieClip {
      if ( !m_initialized ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Cannot create clip because theme is not yet loaded!" );
         return null;
      }
      var clip :MovieClip =
         m_clipFactory.createClipById( clipId, target, name, depth );
      return clip;
   }

   public function getLayoutRules() :LayoutRules {
      // We do not support a layout ruleset, so just return an empty one.
      return new LayoutRules();
   }

   public function getStageSizeConstraints() :SizeConstraints {
      // We do not support size constraints, so just return none.
      return new SizeConstraints( null, null, null, null );
   }

   public function getClipFactory() :IClipFactory {
      return this;
   }

   private function onLoadProgress( loadedBytes :Number, totalBytes :Number )
      :Void {
      dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, this,
         loadedBytes / totalBytes * 100 ) );
   }

   private function onLoadInit() :Void {
      m_loading = false;

      var themeApp :String = String( m_themeTarget[ "getAppName" ]() );
      if ( themeApp != m_appName ) {
         Debug.LIBRARY_LOG.log( LogLevel.ERROR,
            "The theme is for the wrong application: " + themeApp +
            " (" + m_fileUrl + ")!" );
         dispatchEvent( new ThemeEvent( ThemeEvent.THEME_MISMATCH, this,
            m_themeTarget ) );
         return;
      }

      var themeVersion :Number = Number( m_themeTarget[ "getAppVersion" ]() );
      if ( themeVersion != m_appThemeVersion ) {
         Debug.LIBRARY_LOG.log( LogLevel.ERROR,
            "The theme is not for the right version of this application: " +
            themeVersion + " (" + m_fileUrl + ")!" );
         dispatchEvent( new ThemeEvent( ThemeEvent.THEME_MISMATCH, this,
            m_themeTarget ) );
         return;
      }

      m_clipFactory = IClipFactory( m_themeTarget[ "getClipFactory" ]() );
      if ( !( m_clipFactory instanceof IClipFactory ) ) {
         Debug.LIBRARY_LOG.log( LogLevel.ERROR,
            "Could not get a clip factory from the theme (" + m_fileUrl + ")!" );
         dispatchEvent( new ThemeEvent( ThemeEvent.THEME_MISMATCH, this,
            m_themeTarget ) );
         return;
      }

      m_themeTarget[ "addEventListener" ]( Event.COMPLETE, this, themeComplete );
   }

   private function themeComplete() :Void {
      // Warning: Order is important here because listeners will most likely
      // immediately call <code>createClipById()</code>.
      m_initialized = true;

      dispatchEvent( new ThemeEvent( ThemeEvent.COMPLETE, this,
         m_themeTarget ) );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "fileUrl: " + m_fileUrl );
   }

   private var m_fileUrl :String;
   private var m_appName :String;
   private var m_appThemeVersion :Number;

   private var m_themeTarget :MovieClip;

   private var m_loader :MovieClipLoader;
   private var m_loading :Boolean;
   private var m_initialized :Boolean;

   private var m_clipFactory :IClipFactory;
}