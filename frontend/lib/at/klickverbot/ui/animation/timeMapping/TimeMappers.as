import at.klickverbot.ui.animation.timeMapping.CubicMapper;
import at.klickverbot.ui.animation.timeMapping.ITimeMapper;
import at.klickverbot.ui.animation.timeMapping.LinearMapper;
import at.klickverbot.ui.animation.timeMapping.SineMapper;

class at.klickverbot.ui.animation.timeMapping.TimeMappers {
   /**
    * Don't instanciate this class.
    */
   private function TimeMappers() {
   }

   public static var LINEAR :ITimeMapper = new LinearMapper();
   public static var SINE :ITimeMapper = new SineMapper();
   public static var CUBIC :ITimeMapper = new CubicMapper();
}
