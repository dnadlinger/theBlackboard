import at.klickverbot.core.CoreObject;

class at.klickverbot.theBlackboard.model.EntriesSortingType extends CoreObject {
   /**
    * Constructor for enumeration.
    * Private to make other instances than the public static members impossible.
    */
   private function EntriesSortingType() {
   }

   public static var OLD_TO_NEW :EntriesSortingType = new EntriesSortingType();
   public static var NEW_TO_OLD :EntriesSortingType = new EntriesSortingType();
}
