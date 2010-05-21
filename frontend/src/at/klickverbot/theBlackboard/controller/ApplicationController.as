import at.klickverbot.debug.Logger;
import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.controller.auth.AuthHandler;
import at.klickverbot.theBlackboard.controller.auth.CaptchaAuthenticator;
import at.klickverbot.theBlackboard.model.ApplicationModel;
import at.klickverbot.theBlackboard.model.Configuration;
import at.klickverbot.theBlackboard.model.EntriesSortingType;
import at.klickverbot.theBlackboard.service.IAuthService;
import at.klickverbot.theBlackboard.service.ICaptchaAuthService;
import at.klickverbot.theBlackboard.service.IConfigLocationService;
import at.klickverbot.theBlackboard.service.IConfigService;
import at.klickverbot.theBlackboard.service.IEntriesService;
import at.klickverbot.theBlackboard.service.IServiceFactory;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceType;
import at.klickverbot.theBlackboard.view.event.CaptchaAuthViewEvent;
import at.klickverbot.theBlackboard.view.event.EntryViewEvent;

class at.klickverbot.theBlackboard.controller.ApplicationController {
   /**
    * Constructor.
    */
   public function ApplicationController( model :ApplicationModel,
      serviceFactory :IServiceFactory ) {
      m_model = model;
      m_serviceFactory = serviceFactory;

      m_authHandler = null;

      m_configLocationService = m_serviceFactory.createConfigLocationService();
      m_configService = null;
      m_entriesService = null;
      m_authService = null;
      m_captchaAuthService = null;
   }

   public function listenTo( target :IEventDispatcher ) :Void {
      target.addEventListener( EntryViewEvent.LOAD_ENTRY, this, loadEntry );
      target.addEventListener( EntryViewEvent.SAVE_ENTRY, this, saveEntry );
      target.addEventListener( CaptchaAuthViewEvent.SOLVE, this, solveCaptcha );
   }

   public function startApplication() :Void {
      var operation :IOperation = m_configLocationService.loadConfigLocation();
      operation.addEventListener( ResultEvent.RESULT, this, handleConfigLocationResult );
      operation.addEventListener( FaultEvent.FAULT, this, handleFault );
      operation.execute();
   }

   private function handleConfigLocationResult( event :ResultEvent ) :Void {
      var configLocation :ServiceLocation = ServiceLocation( event.result );
      m_configService = m_serviceFactory.createConfigService( configLocation );

      Logger.getLog( "ApplicationController" ).info(
         "Loading configuration from " + configLocation + "." );

      var operation :IOperation = m_configService.loadConfig();
      operation.addEventListener( ResultEvent.RESULT, this, handleConfigResult );
      operation.addEventListener( FaultEvent.FAULT, this, handleFault );
      operation.execute();
   }

   private function handleConfigResult( event :ResultEvent ) :Void {
      m_model.configuration = Configuration( event.result );

      m_authService = m_serviceFactory.createAuthService(
         m_model.configuration.authServiceLocation );
      m_authHandler = new AuthHandler( m_authService );

      m_entriesService = m_serviceFactory.createEntriesService(
         m_model.configuration.entryServiceLocation, [ m_authHandler ] );
      m_captchaAuthService = m_serviceFactory.createCaptchaAuthService(
         m_model.configuration.captchaAuthServiceLocation, [ m_authHandler ] );

      m_captchaAuthenticator =
         new CaptchaAuthenticator( m_captchaAuthService, m_model );
      m_authHandler.setAuthenticator( "captcha", m_captchaAuthenticator );

      var operation :IOperation = m_entriesService.getAllEntries( ENTRIES_SORTING_TYPE );
      operation.addEventListener( ResultEvent.RESULT, this, handleEntriesResult );
      operation.addEventListener( FaultEvent.FAULT, this, handleFault );
      operation.execute();
   }

   private function handleEntriesResult( event :ResultEvent ) :Void {
      var entries :Array = Array( event.result );
      Logger.getLog( "ApplicationController" ).info( entries.length +
         " entries loaded." );
      m_model.entries.setData( entries );
   }

   private function loadEntry( event :EntryViewEvent ) :Void {
      if ( ( event.entry.id == null ) || event.entry.loaded ) {
         // Nothing to do if the target entry is not stored on the server
         // or is already loaded.
         return;
      }

      var operation :IOperation = m_entriesService.loadEntryDetails( event.entry );
      operation.addEventListener( FaultEvent.FAULT, this, handleFault );
      operation.execute();
   }

   private function saveEntry( event :EntryViewEvent ) :Void {
      if ( event.entry.id == null ) {
         var operation :IOperation = m_entriesService.addEntry( event.entry );
         operation.addEventListener( FaultEvent.FAULT, this, handleFault );
         operation.execute();
      } else {
         Logger.getLog( "EntryController" ).error(
            "Saving edited entries is not supported yet: " + event.entry );
      }
   }

   private function solveCaptcha( event :CaptchaAuthViewEvent ) :Void {
      m_captchaAuthenticator.solveCaptcha( event.request, event.solution );
   }

   private function handleFault( event :FaultEvent ) :Void {
      m_model.serviceErrors.push( event );
   }

   private static var CONFIG_LOCATION_SERVICE :ServiceLocation =
      new ServiceLocation( ServiceType.XML, "configLocation.xml" );

   private static var ENTRIES_SORTING_TYPE :EntriesSortingType =
      EntriesSortingType.OLD_TO_NEW;

   private var m_model :ApplicationModel;

   private var m_authHandler :AuthHandler;
   private var m_captchaAuthenticator :CaptchaAuthenticator;

   private var m_serviceFactory :IServiceFactory;
   private var m_configLocationService :IConfigLocationService;
   private var m_configService :IConfigService;
   private var m_entriesService :IEntriesService;
   private var m_authService :IAuthService;
   private var m_captchaAuthService :ICaptchaAuthService;
}
