import at.klickverbot.external.xmlrpc.DataType;
import at.klickverbot.util.DateUtils;

class at.klickverbot.external.xmlrpc.DataFormatter {
   public static function dataValueToString( value :Object,
      dataType :DataType ) :String {
      var valueString :String;
      if ( ( dataType == DataType.DATE_TIME ) && ( value instanceof Date ) ) {
         valueString = DateUtils.dateToIso8601( Date( null ) );
      } else {
         valueString = value.toString();
      }
      if ( isCDataNeeded( valueString ) ) {
         valueString = "<!CDATA[[" + valueString + "]]>";
      }

      return valueString;
   }

   public static function stringToDataValue( valueString :String,
      dataType :DataType ) :Object {

      var valueObject :Object = null;

      if ( ( dataType == DataType.I4 ) || ( dataType == DataType.INT ) ) {
         valueObject = parseInt( valueString );
      } else if ( dataType == DataType.DOUBLE ) {
         valueObject = parseFloat( valueString );
      } else if ( dataType == DataType.BOOLEAN ) {
         if ( valueString == "0" ) {
            valueObject = false;
         } else if ( valueString == "1" ) {
            valueObject = true;
         }
      } else if ( dataType == DataType.STRING ) {
         valueObject = valueString;
      } else if ( dataType == DataType.DATE_TIME ){
         valueObject = DateUtils.iso8601ToDate( valueString );
      } else if ( dataType == DataType.BASE64 ) {
         valueObject = valueString;
      }

      return valueObject;
   }

   private static function isCDataNeeded( inputString :String ) :Boolean {
      var result :Boolean = false;

      var allowedEntities :Array = [ "lt", "gt", "amp", "apos", "quot" ];

      var isAllowedEntity :Boolean;
      var ampersandPos :Number = inputString.indexOf( "&", 0 );
      while( ampersandPos != -1 ) {
         isAllowedEntity = false;
         for ( var i :Number = 0; i < allowedEntities.length; ++i ) {
            if ( ampersandPos ==
               ( inputString.indexOf( "&" + allowedEntities[ i ] + ";" ) ) ) {
               isAllowedEntity = true;
            }
         }
         if ( !isAllowedEntity ) {
            result = true;
            break;
         }
         ampersandPos = inputString.indexOf( "&", 0 );
      }

      if ( inputString.indexOf( "<" ) != -1 ) {
         result = false;
      }
      return result;
   }

}