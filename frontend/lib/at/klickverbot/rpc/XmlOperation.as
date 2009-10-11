import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.ErrorEvent;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.external.xml.SimpleXmlParser;
import at.klickverbot.external.xml.XmlLoader;
import at.klickverbot.rpc.IOperation;

class at.klickverbot.rpc.XmlOperation
   extends EventDispatcher implements IOperation {

   public function XmlOperation( url :String, postData :XML ) {
      super();

      m_xmlLoader = new XmlLoader( url );
      m_xmlLoader.addEventListener( ResultEvent.RESULT, this, handleResult );
      m_xmlLoader.addEventListener( FaultEvent.FAULT, this, handleFault );
      m_xmlLoader.addEventListener( ErrorEvent.ERROR, this, handleError );

      m_postData = postData;
   }

   public function execute() :Void {
      m_xmlLoader.sendAndLoadXml( m_postData );
   }

   private function handleResult( event :ResultEvent ) :Void {
      var xmlParser :SimpleXmlParser = new SimpleXmlParser();
      var rootNode :XMLNode = XMLNode( event.result ).firstChild;
      var parsedResult :Object = xmlParser.parseXml( rootNode );
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, parsedResult ) );
   }

   private function handleFault( event :FaultEvent ) :Void {
      dispatchEvent( event );
   }

   private function handleError( event :ErrorEvent ) :Void {
      dispatchEvent( new FaultEvent( FaultEvent.FAULT, event.target, null,
         event.message ) );
   }

   private var m_xmlLoader :XmlLoader;
   private var m_postData :XML;
}