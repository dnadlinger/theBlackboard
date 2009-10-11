import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.animation.timeMapping.ITimeMapper;

class at.klickverbot.ui.animation.timeMapping.SineMapper extends CoreObject
   implements ITimeMapper {

   public function map( timeIndex :Number ) :Number {
      return -( 0.5 * Math.cos( timeIndex * Math.PI ) ) + 0.5;
   }
}
