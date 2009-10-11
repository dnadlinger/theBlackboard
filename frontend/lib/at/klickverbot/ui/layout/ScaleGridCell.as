import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.VerticalAlign;
import at.klickverbot.ui.components.HorizontalAlign;

class at.klickverbot.ui.layout.ScaleGridCell extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ScaleGridCell( column :HorizontalAlign, row :VerticalAlign ) {
      m_column = column;
      m_row = row;
   }

   public function get column() :HorizontalAlign {
      return m_column;
   }

   public function get row() :VerticalAlign {
      return m_row;
   }

   public static var TOP_LEFT :ScaleGridCell = new ScaleGridCell( HorizontalAlign.LEFT, VerticalAlign.TOP );
   public static var TOP :ScaleGridCell = new ScaleGridCell( HorizontalAlign.CENTER, VerticalAlign.TOP );
   public static var TOP_RIGHT :ScaleGridCell = new ScaleGridCell( HorizontalAlign.RIGHT, VerticalAlign.TOP );

   public static var LEFT :ScaleGridCell = new ScaleGridCell( HorizontalAlign.LEFT, VerticalAlign.CENTER );
   public static var CENTER :ScaleGridCell = new ScaleGridCell( HorizontalAlign.CENTER, VerticalAlign.CENTER );
   public static var RIGHT :ScaleGridCell = new ScaleGridCell( HorizontalAlign.RIGHT, VerticalAlign.CENTER );

   public static var BOTTOM_LEFT :ScaleGridCell = new ScaleGridCell( HorizontalAlign.LEFT, VerticalAlign.BOTTOM );
   public static var BOTTOM :ScaleGridCell = new ScaleGridCell( HorizontalAlign.CENTER, VerticalAlign.BOTTOM );
   public static var BOTTOM_RIGHT :ScaleGridCell = new ScaleGridCell( HorizontalAlign.RIGHT, VerticalAlign.BOTTOM );

   private var m_column :HorizontalAlign;
   private var m_row :VerticalAlign;
}
