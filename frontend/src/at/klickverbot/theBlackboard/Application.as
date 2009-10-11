import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.control.ApplicationStartupEvent;
import at.klickverbot.theBlackboard.control.Controller;
import at.klickverbot.theBlackboard.view.MainView;

// TODO: Refactor out everyting except for #run().

/**
 * The main class of the application.
 * Is invoked directly by the main function.
 *
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

   // TODO: Write a good comment for Application.run() – and put it into the commons too.
   public function run() :Void {
      Logger.getLog( "Application" ).info( "Initializing " + APP_NAME + " " +
         APP_VERSION + "..." );

      // Just initialze the cairngorm framework here.
      // The controller only needs to be initialzed to work as intended.
      var controller :Controller = new Controller();
      controller.init();

      // Set up the main view.
      m_view = new MainView( m_container );

      // Start the application by firing the initial event.
      var startupEvent :ApplicationStartupEvent = new ApplicationStartupEvent();
      startupEvent.dispatch();

      Logger.getLog( "Application" ).info( "done." );
   }

   public static var APP_NAME :String = "theBlackboard";
   public static var APP_VERSION :String = "0.1";

   private var m_container :MovieClip;

   private var m_view :MainView;
}
