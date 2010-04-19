import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.IConfigService;
import at.klickverbot.theBlackboard.service.adapter.ConfigLoadOperation;
import at.klickverbot.theBlackboard.service.backend.IConfigBackend;

class at.klickverbot.theBlackboard.service.adapter.ConfigAdapter
   extends CoreObject implements IConfigService {
   /**
    * Constructor.
    */
   public function ConfigAdapter( backend :IConfigBackend, backendFilters :Array ) {
      m_backend = backend;
      m_backendFilters = backendFilters;
   }

   public function loadConfig() :IOperation {
      return new ConfigLoadOperation( m_backend, m_backendFilters );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "backend: " + m_backend );
   }

   private var m_backend :IConfigBackend;
   private var m_backendFilters :Array;
}
