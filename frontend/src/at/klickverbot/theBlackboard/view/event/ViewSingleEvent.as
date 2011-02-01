import at.klickverbot.event.events.Event;

/**
 * Dispatched by {@link at.klickverbot.theBlackboard.view.ViewSingleToolbar}
 * to signal user actions.
 */
class at.klickverbot.theBlackboard.view.event.ViewSingleEvent extends Event {
	/**
	 * User chose to return back to the index page.
	 */
   public static var BACK :String = "entryDetailsBack";

   public function ViewSingleEvent( type :String, target :Object ) {
      super( type, target );
   }
}
