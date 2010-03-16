import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;

class at.klickverbot.theBlackboard.service.adapter.AdapterOperation
   extends EventDispatcher implements IOperation {

   public function AdapterOperation( backendOperation :IOperation ) {
      m_backendOperation = backendOperation;
      m_backendOperation.addEventListener( ResultEvent.RESULT, this, handleResult );
      m_backendOperation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
   }

   public function execute() :Void {
      m_backendOperation.execute();
   }

   private function handleResult( event :ResultEvent ) :Void {
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, event.result ) );
   }

   private var m_backendOperation :IOperation;
}
