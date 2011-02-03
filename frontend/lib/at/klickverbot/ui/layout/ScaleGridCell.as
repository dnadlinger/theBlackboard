import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.layout.HorizontalPosition;
import at.klickverbot.ui.layout.VerticalPosition;

class at.klickverbot.ui.layout.ScaleGridCell extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ScaleGridCell( column :HorizontalPosition, row :VerticalPosition ) {
      m_column = column;
      m_row = row;
   }

   public function get column() :HorizontalPosition {
      return m_column;
   }

   public function get row() :VerticalPosition {
      return m_row;
   }

   public static var TOP_LEFT :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.LEFT, VerticalPosition.TOP );
   public static var TOP :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.CENTER, VerticalPosition.TOP );
   public static var TOP_RIGHT :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.RIGHT, VerticalPosition.TOP );

   public static var LEFT :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.LEFT, VerticalPosition.MIDDLE );
   public static var CENTER :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.CENTER, VerticalPosition.MIDDLE );
   public static var RIGHT :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.RIGHT, VerticalPosition.MIDDLE );

   public static var BOTTOM_LEFT :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.LEFT, VerticalPosition.BOTTOM );
   public static var BOTTOM :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.CENTER, VerticalPosition.BOTTOM );
   public static var BOTTOM_RIGHT :ScaleGridCell =
      new ScaleGridCell( HorizontalPosition.RIGHT, VerticalPosition.BOTTOM );

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "column: " + m_column,
         "row: " + m_row
      ] );
   }

   private var m_column :HorizontalPosition;
   private var m_row :VerticalPosition;
}
