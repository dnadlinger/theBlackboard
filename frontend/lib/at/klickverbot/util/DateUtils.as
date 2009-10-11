import at.klickverbot.util.NumberUtils;

class at.klickverbot.util.DateUtils {
   public static function dateToIso8601( date :Date ) :String {
      var resultString :String;

      resultString =
         NumberUtils.numberToString( date.getFullYear(), 2 ) +
         NumberUtils.numberToString( date.getMonth() + 1, 2 ) +
         NumberUtils.numberToString( date.getDate(), 2 ) +
         "T" +
         NumberUtils.numberToString( date.getHours(), 2 ) +
         ":" +
         NumberUtils.numberToString( date.getMinutes(), 2 ) +
         ":" +
         NumberUtils.numberToString( date.getSeconds(), 2 );

      return resultString;
   }

   public static function iso8601ToDate( inputString :String ) :Date {
      var temp :Array = inputString.split( "T" );

      var dateString :String = temp[ 0 ];
      var year :Number = parseInt( dateString.substr( 0, 4 ) );
      var month :Number = parseInt( dateString.substr( 4, 2 ) ) - 1;
      var day :Number = parseInt( dateString.substr( 6, 2 ) );

      var timeStrings :Array = String( temp[ 1 ] ).split( ":" );
      var hour :Number = parseInt( timeStrings[ 0 ] );
      var minute :Number = parseInt( timeStrings[ 1 ] );
      var second :Number = parseInt( timeStrings[ 2 ] );

      return new Date( year, month, day, hour, minute, second );
   }
}