import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.layout.ScaleGridCell;
import at.klickverbot.ui.layout.ScaleGridType;

class at.klickverbot.ui.layout.ScaleGridMapping extends CoreObject {
   /**
    * Constructor.
    */
   public function ScaleGridMapping() {
      m_elements = new Array();
      m_gridType = DEFAULT_TYPE;
   }

   public function addElement( elementName :String, location :ScaleGridCell ) :Void {
      m_elements[ elementName ] = location;
   }

   public function getLocationForElement( elementName :String ) :ScaleGridCell {
      return m_elements[ elementName ];
   }

   public function getElementsInLocation( location :ScaleGridCell ) :Array {
      var elementsInLocation :Array = new Array();

      for ( var elementName :String in m_elements ) {
         if ( m_elements[ elementName ] == location ) {
            elementsInLocation.push( elementName );
         }
      }

      return elementsInLocation;
   }

   public function getGridType() :ScaleGridType {
      return m_gridType;
   }

   public function setGridType( type :ScaleGridType ) :Void {
      m_gridType = type;
   }

   private static var DEFAULT_TYPE :ScaleGridType = ScaleGridType.CENTER_STATIC;

   private var m_elements :Object;
   private var m_gridType :ScaleGridType;
}
