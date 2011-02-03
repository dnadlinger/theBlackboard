import at.klickverbot.core.CoreObject;

class at.klickverbot.ui.layout.HorizontalPosition extends CoreObject {
   /**
    * Private constructor. Makes other instances than the public static
    * members impossible.
    */
   private function HorizontalPosition( name :String ) {
      m_name = name;
   }

   public static var LEFT :HorizontalPosition = new HorizontalPosition( "left" );
   public static var CENTER :HorizontalPosition = new HorizontalPosition( "center" );
   public static var RIGHT :HorizontalPosition = new HorizontalPosition( "right" );

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_name );
   }

   private var m_name :String;
}
