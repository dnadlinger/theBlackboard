import at.klickverbot.core.CoreObject;
import at.klickverbot.util.Delegate;

/**
 * Singleton class that provides central access to  SOS, the socket output
 * server from <a>http://sos.powerflashers.com</a>.
 *
 */
class at.klickverbot.debug.SosConnection extends CoreObject {
   private function SosConnection() {
      m_socketReady = false;
      m_messageBuffer = new Array();

      connect( DEFAULT_IP, DEFAULT_PORT, DEFAULT_CLEAR );
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of SosConnection.
    */
   public static function getInstance() :SosConnection {
      if ( m_instance == null ) {
         m_instance = new SosConnection();
      }

      return m_instance;
   }

   public function connect( ip :String, port :Number, clear :Boolean ) :Void {
      // Close the socket if there was any opened before.
      if ( m_socket != null ) {
         m_socket.close();
      }

      m_socket = new XMLSocket();
      m_ip = ip;
      m_port = port;
      m_clear = clear;

      m_socket.onConnect = Delegate.create( this, socketConnected );
      m_socket.connect( ip, port );
   }

   public function send( level :String, message :String ) :Void {
      if ( !m_socketReady ) {
         m_messageBuffer.push( new Array( level, message ) );
      } else {
         m_socket.send( '<showMessage key="' + level + '"/>' + message + "\n" );
      }
   }

   public function getIp() :String {
      return m_ip;
   }

   public function getPort() :Number {
      return m_port;
   }

   private function socketConnected() :Void {
      m_socketReady = true;

      if ( m_clear ) {
         m_socket.send( '<clear/>\n' );
      }

      m_socket.send( '<showMessage key="DEBUG"/>' +
            "klickverbot client connected" );

      for ( var i :Number = 0; i < m_messageBuffer.length; ++i ) {
         send( m_messageBuffer[ i ][ 0 ], m_messageBuffer[ i ][ 1 ] );
      }
   }

   public function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "ip: " + m_ip,
         "port: " + m_port,
         "connected: " + m_socketReady
      ] );
   }

   private static var DEFAULT_IP :String = "localhost";
   private static var DEFAULT_PORT :Number = 4445;
   private static var DEFAULT_CLEAR :Boolean = false;

   private static var m_instance :SosConnection;

   private var m_socket :XMLSocket;
   private var m_socketReady :Boolean;
   private var m_messageBuffer :Array;

   private var m_ip :String;
   private var m_port :Number;
   private var m_clear :Boolean;
}
