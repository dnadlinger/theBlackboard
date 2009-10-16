import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.animation.ITween;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.ui.animation.AlphaTween extends CoreObject
   implements ITween {

   /**
    * Constructor.
    */
   public function AlphaTween( target :IUiComponent, endAlpha :Number,
      startAlpha :Number ) {
      if ( startAlpha == null ) {
         startAlpha = target.getAlpha();
      }

      m_target = target;
      m_startAlpha = startAlpha;
      m_deltaAlpha = endAlpha - m_startAlpha;
   }

   public function render( timeIndex :Number ) :Void {
      m_target.fade( m_startAlpha + m_deltaAlpha * timeIndex );
   }

   private var m_target :IUiComponent;
   private var m_startAlpha :Number;
   private var m_deltaAlpha :Number;
}
