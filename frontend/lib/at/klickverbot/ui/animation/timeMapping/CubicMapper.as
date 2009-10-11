import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.animation.timeMapping.ITimeMapper;

class at.klickverbot.ui.animation.timeMapping.CubicMapper extends CoreObject
   implements ITimeMapper {
   public function map( timeIndex :Number ) :Number {
      timeIndex *= 2;
      if ( timeIndex < 1 ) {
         return 0.5 * Math.pow( timeIndex, 3 );
      } else {
         return 0.5 * ( Math.pow( timeIndex - 2, 3 ) + 2 );
      }
   }
}
