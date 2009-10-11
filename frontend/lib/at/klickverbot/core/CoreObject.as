import at.klickverbot.core.ICoreInterface;
import at.klickverbot.util.TypeUtils;

/**
 * Base class for all at.klickverbot classes.
 *
 */
class at.klickverbot.core.CoreObject implements ICoreInterface {
   public function toString() :String {
      var result :String = "[" + TypeUtils.getTypeName( this );

      var additionalInfo :Array = getInstanceInfo();
      if ( additionalInfo.length > 0 ) {
         result += ": " + additionalInfo.join( ", " );
      }

      result += "]";
      return result;
   }

   private function getInstanceInfo() :Array {
      return new Array();
   }
}
