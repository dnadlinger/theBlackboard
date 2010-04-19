import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.IOperationFilter;

class at.klickverbot.theBlackboard.service.adapter.AdapterOperation
   extends EventDispatcher implements IOperation {

   public function AdapterOperation( backendOperation :IOperation, filters :Array ) {
      m_backendOperation = backendOperation;

      var currentFilter :IOperationFilter;
      var i :Number = filters.length;
      while ( currentFilter = filters[ --i ] ) {
         m_backendOperation = currentFilter.filterOperation( m_backendOperation );
      }

      m_backendOperation.addEventListener( ResultEvent.RESULT, this, handleResult );
      m_backendOperation.addEventListener( FaultEvent.FAULT, this, dispatchEvent );
   }

   public function execute() :Void {
      m_backendOperation.execute();
   }

   private function handleResult( event :ResultEvent ) :Void {
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, event.result ) );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(
         "backendOperation: " + m_backendOperation );
   }

   private var m_backendOperation :IOperation;
}
