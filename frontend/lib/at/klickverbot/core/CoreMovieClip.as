import at.klickverbot.core.ICoreInterface;
import at.klickverbot.util.TypeUtils;

/**
 * Like CoreObject, but inherits from MovieClip.
 */
class at.klickverbot.core.CoreMovieClip extends MovieClip
   implements ICoreInterface {

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
