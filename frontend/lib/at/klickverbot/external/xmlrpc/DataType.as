import at.klickverbot.core.CoreObject;

class at.klickverbot.external.xmlrpc.DataType extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function DataType( name :String ) {
      m_name = name;
   }

   public function getName() :String {
      return m_name;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_name );
   }

   public static var I4 :DataType = new DataType( "i4" );
   public static var INT :DataType = new DataType( "int" );
   public static var DOUBLE :DataType = new DataType( "double" );
   public static var BOOLEAN :DataType = new DataType( "boolean" );
   public static var STRING :DataType = new DataType( "string" );
   public static var DATE_TIME :DataType = new DataType( "dateTime.iso8601" );
   public static var BASE64 :DataType = new DataType( "base64" );

   public static var COMPLEX_TYPE_STRUCT :DataType = new DataType( "struct" );
   public static var COMPLEX_TYPE_ARRAY :DataType = new DataType( "array" );

   private var m_name :String;
}