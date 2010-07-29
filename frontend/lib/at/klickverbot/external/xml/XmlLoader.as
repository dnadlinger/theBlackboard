import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.ErrorEvent;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.external.xml.XmlStatusCodes;

class at.klickverbot.external.xml.XmlLoader extends EventDispatcher {
   public function XmlLoader( url :String ) {
      m_url = url;
   }

   public function loadXml() :Void {
      m_xmlLoaded = false;

      m_xml = new XML();
      m_xml.ignoreWhite = true;

      // Workaround to fix a bug presumably in the ActionScript 2 runtime which
      // causes a warning to appear in the debug Flash Player log if
      // onHttpStatus is not set.
      m_xml[ "onHTTPStatus" ] = function( status :Number ) :Void {};

      var thisHack :XmlLoader = this;
      m_xml.onLoad = function( success :Boolean ) :Void {
         thisHack.m_xmlLoaded = true;
         if ( success ) {
            var xmlStatus :Number = XML( this ).status;
            if ( xmlStatus != 0 ) {
               thisHack.dispatchEvent( new FaultEvent( FaultEvent.FAULT, thisHack,
                  xmlStatus, XmlStatusCodes.getMessageFromCode( xmlStatus ) ) );
            } else {
               thisHack.dispatchEvent( new ResultEvent( ResultEvent.RESULT,
                  thisHack, XMLNode( this ) ) );
            }

         } else {
            thisHack.dispatchEvent( new FaultEvent( FaultEvent.FAULT, thisHack,
               null, "Loading xml failed: " + thisHack.m_url ) );
         }
      };
      m_xml.load( m_url );
   }

   public function sendAndLoadXml( sendXml :XML ) :Void {
      if ( sendXml == null ) {
         loadXml();
         return;
      }
      m_xmlLoaded = false;

      m_xml = new XML();
      m_xml.ignoreWhite = true;

      var thisHack :XmlLoader = this;
      m_xml.onLoad = function( success :Boolean ) :Void {
         thisHack.m_xmlLoaded = true;
         if ( success ) {
            var xmlStatus :Number = XML( this ).status;
            if ( xmlStatus != 0 ) {
               thisHack.dispatchEvent( new FaultEvent( FaultEvent.FAULT, thisHack,
                  xmlStatus, "Parsing xml failed: " + XmlStatusCodes.getMessageFromCode( xmlStatus ) ) );
            } else {
               thisHack.dispatchEvent( new ResultEvent( ResultEvent.RESULT,
                  thisHack, XMLNode( this ) ) );
            }

         } else {
            thisHack.dispatchEvent(
               new ErrorEvent( ErrorEvent.ERROR, thisHack,
                  "Loading xml failed: " + thisHack.m_url ) );
         }
      };

      sendXml.sendAndLoad( m_url, m_xml );
   }

   public function isXmlLoaded() :Boolean {
      return m_xmlLoaded;
   }

   public function getUrl() :String {
      return m_url;
   }

   public function getXml() :XMLNode {
      if ( !m_xmlLoaded ) {
         return null;
      } else {
         return m_xml;
      }
   }

   public function getIgnoreWhite() :Boolean {
      return m_xml.ignoreWhite;
   }
   public function setIgnoreWhite( to :Boolean ) :Void {
      m_xml.ignoreWhite = to;
   }

   private var m_url :String;

   private var m_xml :XML;
   private var m_sendXml :XML;
   private var m_xmlLoaded :Boolean;
}
