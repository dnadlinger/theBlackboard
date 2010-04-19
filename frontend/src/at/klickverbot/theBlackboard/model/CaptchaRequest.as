import at.klickverbot.event.EventDispatcher;
import at.klickverbot.theBlackboard.model.CaptchaRequestChangeEvent;

class at.klickverbot.theBlackboard.model.CaptchaRequest extends EventDispatcher {
   public function CaptchaRequest() {
      m_id = null;
   }

   public function get id() :Number {
      return m_id;
   }
   public function set id( to :Number ) :Void {
      var oldValue :Number = m_id;
      if ( oldValue != to ) {
         m_id = to;
         dispatchEvent( new CaptchaRequestChangeEvent(
            CaptchaRequestChangeEvent.ID, this, oldValue, to ) );
      }
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "id: " + m_id
      ] );
   }

   private var m_id :Number;
}
