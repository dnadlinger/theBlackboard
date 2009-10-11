import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.themed.Button;

/**
 * Class for symbolizing a DrawingToolbox button to number value mapping.
 * Would not be needed if ActionScript 2 supported "real" hashes with Objects
 * as keys.
 *
 */
class at.klickverbot.theBlackboard.view.ButtonForNumber extends CoreObject {
   /**
    * Constructor.
    */
   public function ButtonForNumber( button :Button, number :Number ) {
      m_button = button;
      m_number = number;
   }

   public function get button() :Button {
      return m_button;
   }
   public function set button( to :Button ) :Void {
      m_button = to;
   }

   public function get number() :Number {
      return m_number;
   }
   public function set number( to :Number ) :Void {
      m_number = to;
   }

   private var m_button :Button;
   private var m_number :Number;
}
