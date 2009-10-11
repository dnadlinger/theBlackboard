import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.animation.timeMapping.ITimeMapper;

class at.klickverbot.ui.animation.timeMapping.LinearMapper extends CoreObject
   implements ITimeMapper {

   public function map( timeIndex :Number ) :Number {
      return timeIndex;
   }
}
