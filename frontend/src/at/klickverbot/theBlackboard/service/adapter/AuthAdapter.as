import at.klickverbot.core.CoreObject;
import at.klickverbot.rpc.IOperation;
import at.klickverbot.theBlackboard.service.IAuthService;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.backend.IAuthBackend;

class at.klickverbot.theBlackboard.service.adapter.AuthAdapter
   extends CoreObject implements IAuthService {
   /**
    * Constructor.
    */
   public function AuthAdapter( backend :IAuthBackend, backendFilters :Array ) {
      m_backend = backend;
      m_backendFilters = backendFilters;
   }

   public function getAuthSetsForMethod( methodId :String ) :IOperation {
      return new AdapterOperation(
         m_backend.getAuthSetsForMethod( methodId ), m_backendFilters );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "backend: " + m_backend );
   }

   private var m_backend :IAuthBackend;
   private var m_backendFilters :Array;
}
