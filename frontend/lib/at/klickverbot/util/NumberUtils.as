
class at.klickverbot.util.NumberUtils {
   public static function numberToString( number :Number, minLength :Number )
      :String {

      var numberNegative :Boolean = false;
      if ( number < 0 ) {
         numberNegative = true;
         number *= -1;
      }

      var resultString :String = number.toString();
      while ( resultString.length < minLength ) {
         resultString = "0" + resultString;
      }

      if ( numberNegative ) {
         resultString = "-" + resultString;
      }

      return resultString;
   }
}