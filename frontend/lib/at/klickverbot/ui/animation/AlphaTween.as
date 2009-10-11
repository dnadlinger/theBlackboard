import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.animation.ITween;

class at.klickverbot.ui.animation.AlphaTween extends CoreObject
   implements ITween {

   /**
    * Constructor.
    */
   public function AlphaTween( target :IUiComponent, endAlpha :Number ) {
      m_target = target;
      m_startAlpha = m_target.getAlpha();
      m_deltaAlpha = endAlpha - m_startAlpha;
   }

   public function render( timeIndex :Number ) :Void {
      m_target.fade( m_startAlpha + m_deltaAlpha * timeIndex );
   }

   private var m_target :IUiComponent;
   private var m_startAlpha :Number;
   private var m_deltaAlpha :Number;
}
