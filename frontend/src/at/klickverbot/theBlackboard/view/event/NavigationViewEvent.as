import at.klickverbot.event.events.Event;

class at.klickverbot.theBlackboard.view.event.NavigationViewEvent extends Event {
   public static var PREVIOUS_PAGE :String = "navigationViewPreviousPage";
   public static var NEXT_PAGE :String = "navigationViewNextPage";
   public static var NEW_ENTRY :String = "navigationViewNewEntry";

   public function NavigationViewEvent( type :String, target :Object ) {
      super( type, target );
   }
}
