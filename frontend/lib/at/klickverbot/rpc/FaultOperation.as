import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.rpc.IOperation;

class at.klickverbot.rpc.FaultOperation extends EventDispatcher implements IOperation {
   public function FaultOperation( faultCode :Number, faultString :String ) {
      m_faultCode = faultCode;
      m_faultString = faultString;
   }

   public function execute() :Void {
      dispatchEvent( new FaultEvent( FaultEvent.FAULT, this, m_faultCode, m_faultString ) );
   }

   private var m_faultCode :Number;
   private var m_faultString :String;
}
