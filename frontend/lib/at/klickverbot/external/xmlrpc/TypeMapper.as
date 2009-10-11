import at.klickverbot.core.CoreObject;
import at.klickverbot.external.xmlrpc.DataType;

class at.klickverbot.external.xmlrpc.TypeMapper extends CoreObject {
   /**
    * Constructor.
    */
   public function TypeMapper( integerDefaultType :DataType,
      defaultType :DataType ) {

      // Default to <int> for integers.
      if ( integerDefaultType == null ) {
         integerDefaultType = DataType.INT;
      }

      // Default to <string> for untyped data because all other data types can
      // be converted using their toString() method.
      if ( defaultType == null ) {
         defaultType = DataType.STRING;
      }

      m_integerDefaultType = integerDefaultType;
      m_defaultType = defaultType;
   }

   public function getDataType( value :Object ) :DataType {
      var strictType :DataType = getDataTypeStrict( value );
      if ( strictType == null ) {
         return m_defaultType;
      } else {
         return strictType;
      }
   }

   public function getDataTypeStrict( value :Object ) :DataType {
      if ( typeof( value ) == "number" ) {
         var numberValue :Number = Number( value );
         if ( numberValue == Math.floor( numberValue ) ) {
            return m_integerDefaultType;
         } else {
            return DataType.DOUBLE;
         }
      } else if ( typeof( value ) == "boolean" ) {
         return DataType.BOOLEAN;
      } else if ( typeof( value ) == "string" ) {
         return DataType.STRING;
      } else if ( typeof( value ) == "object" ) {
         if ( value instanceof Date ) {
            return DataType.DATE_TIME;
         }
      }
      return null;
   }

   public function isSimpleType( type :DataType ) :Boolean {
      if ( ( type == DataType.I4 ) || ( type == DataType.INT ) ||
         ( type == DataType.DOUBLE ) || ( type == DataType.BOOLEAN ) ||
         ( type == DataType.STRING ) || ( type == DataType.DATE_TIME ) ||
         ( type == DataType.BASE64 ) ) {
         return true;
      }
      return false;
   }

   public function isComplexType( type :DataType ) :Boolean {
      if ( ( type == DataType.COMPLEX_TYPE_STRUCT ) ||
         ( type == DataType.COMPLEX_TYPE_ARRAY ) ) {
         return true;
      }
      return false;
   }

   public function getTypeFromString( typeString :String ) :DataType {
      var dataTypes :Array = [ DataType.I4, DataType.INT, DataType.DOUBLE,
         DataType.BOOLEAN, DataType.STRING, DataType.DATE_TIME, DataType.BASE64,
         DataType.COMPLEX_TYPE_STRUCT, DataType.COMPLEX_TYPE_ARRAY ];

      var currentType :DataType;
      for ( var i :Number = 0; i < dataTypes.length; ++i ) {
         currentType = dataTypes[ i ];
         if ( typeString == currentType.getName() ) {
            return currentType;
         }
      }

      return null;
   }

   private var m_integerDefaultType :DataType;
   private var m_defaultType :DataType;
}