import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.theBlackboard.control.Controller;

class at.klickverbot.theBlackboard.control.ApplicationStartupEvent
   extends CairngormEvent {

   /**
    * Constructor.
    */
   public function ApplicationStartupEvent() {
      super( Controller.APPLICATION_STARTUP );
   }
}
