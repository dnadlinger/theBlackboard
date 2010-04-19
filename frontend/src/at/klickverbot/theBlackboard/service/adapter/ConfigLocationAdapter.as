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
   public function ConfigLocationAdapter( backend :IConfigLocationBackend,
      backendFilters :Array ) {

      m_backend = backend;
      m_backendFilters = backendFilters;
   }

   public function loadConfigLocation() :IOperation {
      return new ConfigLocationLoadOperation( m_backend, m_backendFilters );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "backend: " + m_backend );
   }

   private var m_backend :IConfigLocationBackend;
   private var m_backendFilters :Array;
}
