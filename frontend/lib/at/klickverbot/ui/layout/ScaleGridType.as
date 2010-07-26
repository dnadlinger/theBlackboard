/**
 * Enumerates the strategies for determining the dimensions of the cells in the
 * ScaleGrid of a container.
 */
class at.klickverbot.ui.layout.ScaleGridType {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ScaleGridType() {
   }

   /**
    * Look at the contents of the center cell to determine its dimensions and
    * thus the whole scale grid.
    *
    * This obviously fails if there are no contents in the center cell.
    */
   public static var CENTER_STATIC :ScaleGridType = new ScaleGridType();

   /**
    * Define the center cell by making sure that no contents of the border cells
    * extend into the it.
    */
   public static var BORDERS_STATIC :ScaleGridType = new ScaleGridType();
}
