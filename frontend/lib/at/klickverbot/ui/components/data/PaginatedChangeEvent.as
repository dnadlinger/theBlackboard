import at.klickverbot.event.events.PropertyChangeEvent;

class at.klickverbot.ui.components.data.PaginatedChangeEvent extends PropertyChangeEvent {
   public static var CURRENT_PAGE :String = "changeCurrentPage";
   public static var PAGE_COUNT :String = "changePageCount";

   public function PaginatedChangeEvent( type :String, target :Object,
      oldValue :Object, newValue :Object ) {
      super( type, target, oldValue, newValue );
   }
}
