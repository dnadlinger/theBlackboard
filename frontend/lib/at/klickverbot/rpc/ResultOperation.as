import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.rpc.IOperation;

class at.klickverbot.rpc.ResultOperation extends EventDispatcher
   implements IOperation {

   public function ResultOperation( returnValue :Object ) {
      m_returnValue = returnValue;
   }

   public function execute() :Void {
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, m_returnValue ) );
   }

   private var m_returnValue :Object;
}
