import at.klickverbot.core.CoreObject;

class at.klickverbot.ui.layout.VerticalPosition extends CoreObject {
   /**
    * Private constructor. Makes other instances than the public static
    * members impossible.
    */
   private function VerticalPosition( name :String ) {
      m_name = name;
   }

   public static var TOP :VerticalPosition = new VerticalPosition( "top" );
   public static var MIDDLE :VerticalPosition = new VerticalPosition( "middle" );
   public static var BOTTOM :VerticalPosition = new VerticalPosition( "bottom" );

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_name );
   }

   private var m_name :String;
}
