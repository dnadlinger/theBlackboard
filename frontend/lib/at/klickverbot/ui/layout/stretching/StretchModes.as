import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.layout.stretching.FillStretching;
import at.klickverbot.ui.layout.stretching.IStretchMode;
import at.klickverbot.ui.layout.stretching.NoStretching;
import at.klickverbot.ui.layout.stretching.UniformFillStretching;
import at.klickverbot.ui.layout.stretching.UniformStretching;

class at.klickverbot.ui.layout.stretching.StretchModes extends CoreObject {
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
