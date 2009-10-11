import at.klickverbot.event.events.Event;

class at.klickverbot.event.events.FaultEvent extends Event {
   public static var FAULT :String = "faFault";

   public function FaultEvent( type :String, target :Object, faultCode :Number,
      faultString :String  ) {
      super( type, target );
      m_faultCode = faultCode;
      m_faultString = faultString;
   }

   public function get faultCode() :Number {
      return m_faultCode;
   }
   public function set faultCode( to :Number ) :Void {
      m_faultCode = to;
   }

   public function get faultString() :String {
      return m_faultString;
   }
   public function set faultString( to :String ) :Void {
      m_faultString = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "faultCode: " + m_faultCode,
         "faultString: " + m_faultString
      ] );
   }

   private var m_faultCode :Number;
   private var m_faultString :String;
}