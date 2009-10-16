import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.animation.ITween;

class at.klickverbot.ui.animation.PropertyTween extends CoreObject
   implements ITween {

   /**
    * Constructor.
    */
   public function PropertyTween( target :Object, propertyName :String,
      endValue :Number, startValue :Number ) {
      if ( startValue == null ) {
         startValue = target[ propertyName ];
      }

      m_target = target;
      m_propertyName = propertyName;
      m_startValue = startValue;
      m_deltaValue = endValue - m_startValue;
   }

   public function render( timeIndex :Number ) :Void {
      m_target[ m_propertyName ] = m_startValue + m_deltaValue * timeIndex;
   }

   private var m_target :Object;
   private var m_propertyName :String;
   private var m_startValue :Number;
   private var m_deltaValue :Number;
}
