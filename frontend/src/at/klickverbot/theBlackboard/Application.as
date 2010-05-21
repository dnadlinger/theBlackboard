import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.controller.ApplicationController;
import at.klickverbot.theBlackboard.model.ApplicationModel;
import at.klickverbot.theBlackboard.service.ServiceFactory;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceType;
import at.klickverbot.theBlackboard.view.ApplicationView;

/**
 * The main class of the application.
 *
 * It is invoked directly by the main function.
 */
class at.klickverbot.theBlackboard.Application extends CoreObject {
   /**
    * Constructor.
    *
    * @param container The application's container MovieClip
    *        (_root in most cases).
    */
   public function Application( container :MovieClip ) {
      Stage.align = "TL";
      Stage.scaleMode = "noScale";

      m_container = container;
   }

   public function run() :Void {
      Logger.getLog( "Application" ).info( "Initializing " + APP_NAME + " " +
         APP_VERSION + "..." );

      m_model = new ApplicationModel();

      m_view = new ApplicationView( m_model, m_container );

      m_serviceFactory = new ServiceFactory( CONFIG_LOCATION_LOCATION );
      m_controller = new ApplicationController( m_model, m_serviceFactory );
      m_controller.listenTo( m_view );

      m_controller.startApplication();

      Logger.getLog( "Application" ).info( "done." );
   }

   public static var APP_NAME :String = "theBlackboard";
   public static var APP_VERSION :String = "0.1";

   private static var CONFIG_LOCATION_LOCATION :ServiceLocation =
      new ServiceLocation( ServiceType.XML, "configLocation.xml" );

   private var m_container :MovieClip;

   private var m_model :ApplicationModel;
   private var m_view :ApplicationView;
   private var m_serviceFactory :ServiceFactory;
   private var m_controller :ApplicationController;
}
