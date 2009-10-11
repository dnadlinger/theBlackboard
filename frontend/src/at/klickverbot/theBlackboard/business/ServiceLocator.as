import at.klickverbot.cairngorm.business.IServiceLocator;
import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.business.ServiceType;
import at.klickverbot.theBlackboard.service.IConfigLocationService;
import at.klickverbot.theBlackboard.service.IConfigService;
import at.klickverbot.theBlackboard.service.IEntriesService;
import at.klickverbot.theBlackboard.service.LocalEntriesService;
import at.klickverbot.theBlackboard.service.XmlConfigLocationService;
import at.klickverbot.theBlackboard.service.XmlConfigService;
import at.klickverbot.theBlackboard.service.XmlRpcConfigService;
import at.klickverbot.theBlackboard.service.XmlRpcEntriesService;

class at.klickverbot.theBlackboard.business.ServiceLocator extends CoreObject
   implements IServiceLocator {

   private function ServiceLocator() {
      m_configLocationService = null;
      m_configService = null;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of ServiceLocator.
    */
   public static function getInstance() :ServiceLocator {
      if ( m_instance == null ) {
         m_instance = new ServiceLocator();
      }
      return m_instance;
   }

   public function initConfigLocationService( location :ServiceLocation ) :Boolean {
      if ( location.type == ServiceType.PLAIN_XML ) {
         m_configLocationService = new XmlConfigLocationService( String( location.info ) );
         return true;
      } else {
         m_configLocationService = null;
         return false;
      }
   }

   public function initConfigService( location :ServiceLocation ) :Boolean {
      if ( location.type == ServiceType.XML_RPC ) {
         m_configService = new XmlRpcConfigService( String( location.info ) );
         return true;
      } else if ( location.type == ServiceType.PLAIN_XML ) {
         m_configService = new XmlConfigService( String( location.info ) );
         return true;
      } else {
         m_configService = null;
         return false;
      }
   }

   public function initEntriesService( location :ServiceLocation ) :Boolean {
      if ( location.type == ServiceType.XML_RPC ) {
         m_entriesService = new XmlRpcEntriesService( String( location.info ) );
         return true;
      } else if ( location.type == ServiceType.LOCAL ) {
         m_entriesService = new LocalEntriesService( String( location.info ) );
         return true;
      } else {
         m_entriesService = null;
         return false;
      }
   }

   public function get configLocationService() :IConfigLocationService {
      if ( m_configLocationService == null ) {
         Logger.getLog( "ServiceLocator" ).warn( "ConfigLocationService not set yet." );
      }
      return m_configLocationService;
   }

   public function get configService() :IConfigService {
      if ( m_configService == null ) {
         Logger.getLog( "ServiceLocator" ).warn( "ConfigService not set yet." );
      }
      return m_configService;
   }

   public function get entriesService() :IEntriesService {
      if ( m_entriesService == null ) {
         Logger.getLog( "ServiceLocator" ).warn( "EntriesService not set yet." );
      }
      return m_entriesService;
   }

   private static var m_instance :ServiceLocator;

   private var m_configLocationService :IConfigLocationService;
   private var m_configService :IConfigService;
   private var m_entriesService :IEntriesService;
}