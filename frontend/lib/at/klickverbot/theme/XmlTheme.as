import at.klickverbot.debug.Debug;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.event.events.ThemeEvent;
import at.klickverbot.external.xml.SimpleXmlParser;
import at.klickverbot.external.xml.XmlLoader;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.IClipFactory;
import at.klickverbot.theme.ITheme;
import at.klickverbot.theme.LayoutRules;
import at.klickverbot.theme.LibraryClipFactory;
import at.klickverbot.theme.SizeConstraints;
import at.klickverbot.theme.ThemeConfig;
import at.klickverbot.util.Delegate;

class at.klickverbot.theme.XmlTheme
   extends EventDispatcher implements ITheme, IClipFactory {

   /**
    * Constructor.
    */
   public function XmlTheme( themeUrl :String, applicationName :String,
      applicationVersion :String ) {
      m_themeUrl = themeUrl;
      m_expectedAppName = applicationName;
      m_expectedAppVersion = applicationVersion;

      m_loading = false;
      m_ready = false;

      m_xmlLoader = new XmlLoader( themeUrl + CONFIG_XML_FILENAME );
      m_xmlLoader.addEventListener( ResultEvent.RESULT, this, handleXmlLoaded );
      m_xmlLoader.addEventListener( FaultEvent.FAULT, this, handleXmlFault );

      m_themeSwfLoader = new MovieClipLoader();
   }

   public function initTheme( target :MovieClip ) :Boolean {
      if ( m_loading || m_ready ) {
         Debug.LIBRARY_LOG.warn(
            "Cannot init theme because it is already loading or ready." );
         return false;
      }

      var depth :Number = target.getNextHighestDepth();
      var name :String = "XmlTheme@" + String( depth );
      m_themeTarget = target.createEmptyMovieClip( name, depth );

      m_loading = true;
      m_xmlLoader.loadXml();
      return true;
   }

   public function destroyTheme() :Void {
      if ( !m_ready ) {
         Debug.LIBRARY_LOG.warn( "Attemped to destroy theme that is not ready." );
         return;
      }

      dispatchEvent( new ThemeEvent( ThemeEvent.DESTROY, this, m_themeTarget ) );
      m_ready = false;

      m_themeSwfLoader.unloadClip( m_themeTarget );
      m_themeConfig = null;
      m_clipFactory = null;
   }

   public function createClipById( clipId :ClipId, target :MovieClip, name :String,
      depth :Number ) :MovieClip {
      if ( !m_ready ) {
         Debug.LIBRARY_LOG.warn(
            "Cannot create clip by id because theme is not ready yet." );
         return null;
      }
      return m_clipFactory.createClipById( clipId, target, name, depth );
   }

   public function getLayoutRules() :LayoutRules {
      return m_themeConfig.getLayoutRules();
   }

   public function getStageSizeConstraints() :SizeConstraints {
      return m_themeConfig.getStageSizeConstraints();
   }

   public function getClipFactory() :IClipFactory {
      return this;
   }

   private function handleXmlLoaded( event :ResultEvent ) :Void {
      var resultXml :XMLNode = XMLNode( event.result );
      var xmlParser :SimpleXmlParser = new SimpleXmlParser();
      var resultObject :Object = xmlParser.parseXml( resultXml.firstChild );

      m_themeConfig = ThemeConfig.fromObject( resultObject );
      if ( m_themeConfig == null ) {
         Debug.LIBRARY_LOG.warn( "Invalid theme config xml." );
         dispatchEvent( new ThemeEvent( ThemeEvent.THEME_MISMATCH, this,
            m_themeTarget ) );
         return;
      }

      if ( m_themeConfig.getApplicationName() != m_expectedAppName ) {
         Debug.LIBRARY_LOG.warn( "The theme is not for this application (" +
            m_expectedAppName + "), but for " + m_themeConfig.getApplicationName() );
         dispatchEvent( new ThemeEvent( ThemeEvent.THEME_MISMATCH, this,
            m_themeTarget ) );
         return;
      }

      if ( m_themeConfig.getApplicationVersion() != m_expectedAppVersion ) {
         Debug.LIBRARY_LOG.warn( "The theme is not for the right " +
            "version of this application (" + m_expectedAppVersion +
            ", but the theme is for " + m_themeConfig.getApplicationVersion() + ")." );
         dispatchEvent( new ThemeEvent( ThemeEvent.THEME_MISMATCH, this,
            m_themeTarget ) );
         return;
      }

      var absoluteUrl :String;
      if ( m_themeConfig.getThemeSwfUrl().substring( 0, 7 ) == "http://" ) {
         absoluteUrl = m_themeConfig.getThemeSwfUrl();
      } else {
         absoluteUrl	= m_themeUrl + "/" + m_themeConfig.getThemeSwfUrl();
      }

      m_themeSwfLoader.addListener( this );
      m_themeSwfLoader.loadClip( absoluteUrl, m_themeTarget );
   }

   private function handleXmlFault( event :FaultEvent ) :Void {
      Debug.LIBRARY_LOG.warn( "Loading theme xml failed: " + event.faultString );
      dispatchEvent( new ThemeEvent( ThemeEvent.EXTERN_FAILED, this,
         m_themeTarget ) );
   }

   private function onLoadInit( target :MovieClip ) :Void {
      m_loading = false;

      if ( m_themeConfig.getClipFactoryType() == LIBRARY_CLIP_FACTORY ) {
         m_clipFactory = new LibraryClipFactory( m_themeTarget );
      } else if ( m_themeConfig.getClipFactoryType() == CUSTOM_CLIP_FACTORY ) {
         m_clipFactory = IClipFactory( m_themeTarget[ "getClipFactory" ]() );
      } else {
         Debug.LIBRARY_LOG.warn( "Invalid clip factory type in " +
            "theme config, defaulting to LibraryMcFactory." );
         m_clipFactory = new LibraryClipFactory( m_themeTarget );
      }

      m_themeTarget.onEnterFrame = Delegate.create( this, checkSwfProgress );
   }

   private function onLoadError( target :MovieClip, errorCode :String,
      httpStatus :Number ) :Void {
      Debug.LIBRARY_LOG.warn( "Loading theme swf failed due to " +
         errorCode + ( ( httpStatus == 0 ) ? "" : httpStatus ) );
      dispatchEvent( new ThemeEvent( ThemeEvent.EXTERN_FAILED, this,
         m_themeTarget ) );
   }

   private function checkSwfProgress() :Void {
      if ( m_themeTarget._currentframe == m_themeTarget._totalframes ) {
         delete m_themeTarget.onEnterFrame;

         // Warining: Order is important here because listeners will most likely
         // call createClipById() immediately.
         m_ready = true;
         dispatchEvent( new ThemeEvent( ThemeEvent.COMPLETE, this,
            m_themeTarget ) );
      }
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "themeUrl: " + m_themeUrl );
   }

   private static var CONFIG_XML_FILENAME :String = "/themeConfig.xml";

   private static var LIBRARY_CLIP_FACTORY :String = "library";
   private static var CUSTOM_CLIP_FACTORY :String = "custom";

   private var m_themeUrl :String;

   private var m_xmlLoader :XmlLoader;
   private var m_themeSwfLoader :MovieClipLoader;
   private var m_loading :Boolean;
   private var m_ready :Boolean;

   private var m_themeConfig :ThemeConfig;
   private var m_expectedAppName :String;
   private var m_expectedAppVersion :String;

   private var m_themeTarget :MovieClip;
   private var m_clipFactory :IClipFactory;
}
