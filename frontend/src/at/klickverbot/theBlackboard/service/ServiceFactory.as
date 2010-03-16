import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.service.IConfigLocationService;
import at.klickverbot.theBlackboard.service.IConfigService;
import at.klickverbot.theBlackboard.service.IEntriesService;
import at.klickverbot.theBlackboard.service.IServiceFactory;
import at.klickverbot.theBlackboard.service.ServiceLocation;
import at.klickverbot.theBlackboard.service.ServiceType;
import at.klickverbot.theBlackboard.service.adapter.ConfigAdapter;
import at.klickverbot.theBlackboard.service.adapter.ConfigLocationAdapter;
import at.klickverbot.theBlackboard.service.adapter.EntriesAdapter;
import at.klickverbot.theBlackboard.service.backend.ConfigLocationXmlBackend;
import at.klickverbot.theBlackboard.service.backend.ConfigXmlBackend;
import at.klickverbot.theBlackboard.service.backend.ConfigXmlRpcBackend;
import at.klickverbot.theBlackboard.service.backend.EntriesLocalBackend;
import at.klickverbot.theBlackboard.service.backend.EntriesXmlRpcBackend;
import at.klickverbot.theBlackboard.service.backend.IConfigBackend;
import at.klickverbot.theBlackboard.service.backend.IConfigLocationBackend;
import at.klickverbot.theBlackboard.service.backend.IEntriesBackend;

class at.klickverbot.theBlackboard.service.ServiceFactory
   extends CoreObject implements IServiceFactory {

   /**
    * Constructor.
    */
   public function ServiceFactory( configLocationLocation :ServiceLocation ) {
      m_configLocationLocation = configLocationLocation;
   }

   public function createConfigLocationService() :IConfigLocationService {
      var backend :IConfigLocationBackend = null;

      if ( m_configLocationLocation.type == ServiceType.XML ) {
         backend = new ConfigLocationXmlBackend( String( m_configLocationLocation.info ) );
      }

      if ( backend == null ) {
         Logger.getLog( "ServiceFactory" ).warn(
           "Unknown config location service type: " + m_configLocationLocation.type );
         return null;
      }

      return new ConfigLocationAdapter( backend );
   }

   public function createConfigService( location :ServiceLocation ) :IConfigService {
      var backend :IConfigBackend = null;

      if ( location.type == ServiceType.XML_RPC ) {
         backend = new ConfigXmlRpcBackend( String( location.info ) );
      } else if ( location.type == ServiceType.XML ) {
         backend = new ConfigXmlBackend( String( location.info ) );
      }

      if ( backend == null ) {
         Logger.getLog( "ServiceFactory" ).warn(
           "Unknown config service type: " + location.type );
         return null;
      }

      return new ConfigAdapter( backend );
   }

   public function createEntriesService( location :ServiceLocation ) :IEntriesService {
      var backend :IEntriesBackend = null;

      if ( location.type == ServiceType.XML_RPC ) {
         backend = new EntriesXmlRpcBackend( String( location.info ) );
      } else if ( location.type == ServiceType.LOCAL ) {
         backend = new EntriesLocalBackend( String( location.info ) );
      }

      if ( backend == null ) {
         Logger.getLog( "ServiceFactory" ).warn(
           "Unknown entries service type: " + location.type );
         return null;
      }

      return new EntriesAdapter( backend );
   }

   private var m_configLocationLocation :ServiceLocation;
}
