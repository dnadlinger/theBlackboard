import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.stretching.FillStretching;
import at.klickverbot.ui.components.stretching.IStretchMode;
import at.klickverbot.ui.components.stretching.NoStretching;
import at.klickverbot.ui.components.stretching.UniformFillStretching;
import at.klickverbot.ui.components.stretching.UniformStretching;

class at.klickverbot.ui.components.stretching.StretchModes extends CoreObject {
   /**
    * Don't instanciate this class.
    */
   private function StretchModes() {
   }

   public static var NONE :IStretchMode = new NoStretching();
   public static var UNIFORM :IStretchMode = new UniformStretching();
   public static var UNIFORM_FILL :IStretchMode = new UniformFillStretching();
   public static var FILL :IStretchMode = new FillStretching();
}
