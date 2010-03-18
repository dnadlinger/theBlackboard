import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.themed.Label;

class at.klickverbot.theBlackboard.view.TooltipLabel extends Label {
   public function TooltipLabel( text :String ) {
      super( AppClipId.TOOLTIP_LABEL, text );
   }
}
