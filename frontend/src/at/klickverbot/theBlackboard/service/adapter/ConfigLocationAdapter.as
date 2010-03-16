import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.IConfigLocationService;
import at.klickverbot.theBlackboard.service.adapter.ConfigLocationLoadOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigLocationBackend;

class at.klickverbot.theBlackboard.service.adapter.ConfigLocationAdapter
   extends CoreObject implements IConfigLocationService {

   /**
    * Constructor.
    */
   public function ConfigLocationAdapter( backend :IConfigLocationBackend ) {
      m_backend = backend;
   }

   public function loadConfigLocation() :IOperation {
      return new ConfigLocationLoadOperation( m_backend );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "backend: " + m_backend );
   }

   private var m_backend :IConfigLocationBackend;
}
