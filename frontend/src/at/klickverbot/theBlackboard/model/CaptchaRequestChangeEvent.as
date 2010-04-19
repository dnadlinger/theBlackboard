import at.klickverbot.event.events.PropertyChangeEvent;

class at.klickverbot.theBlackboard.model.CaptchaRequestChangeEvent extends PropertyChangeEvent {
   public static var ID :String = "changeId";

   public function CaptchaRequestChangeEvent( type :String, target :Object,
      oldValue :Object, newValue :Object ) {
      super( type, target, oldValue, newValue );
   }
}
