import at.klickverbot.event.events.Event;

class at.klickverbot.theBlackboard.view.event.SubmitDiscardEvent extends Event {
   public static var SUBMIT :String = "submitDiscardSubmit";
   public static var DISCARD :String = "submitDiscardDiscard";

   public function SubmitDiscardEvent( type :String, target :Object ) {
      super( type, target );
   }
}
