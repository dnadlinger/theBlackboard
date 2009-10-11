import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.ErrorEvent;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.external.xml.XmlLoader;
import at.klickverbot.external.xmlrpc.MethodFault;
import at.klickverbot.external.xmlrpc.Request;
import at.klickverbot.external.xmlrpc.Response;
import at.klickverbot.rpc.IOperation;

class at.klickverbot.rpc.XmlRpcOperation
   extends EventDispatcher implements IOperation {

   public function XmlRpcOperation( url :String, methodName :String,
      methodParams :Array ) {

      m_request = new Request( methodName );
      m_request.addParams( methodParams );

      m_xmlLoader = new XmlLoader( url );
      m_xmlLoader.addEventListener( ResultEvent.RESULT, this, handleResult );
      m_xmlLoader.addEventListener( FaultEvent.FAULT, this, handleFault );
      m_xmlLoader.addEventListener( ErrorEvent.ERROR, this, handleError );
   }

   public function execute() :Void {
      m_xmlLoader.sendAndLoadXml( m_request.getXmlData() );
   }

   private function handleResult( event :ResultEvent ) :Void {
      var response :Response = new Response();
      if ( !response.parseResponse( XMLNode( event.result ) ) ) {
         dispatchEvent( new FaultEvent( FaultEvent.FAULT, this, null,
            "Error parsing xmlrpc response: [" + event.result + "]" ) );
         return;
      }

      if ( response.isFault() ) {
         var methodFault :MethodFault = response.getFault();
         dispatchEvent( new FaultEvent( FaultEvent.FAULT, this,
            methodFault.faultCode, methodFault.faultString ) );
      } else {
         dispatchEvent( new ResultEvent( ResultEvent.RESULT, this,
            response.getReturnValue() ) );
      }
   }

   private function handleFault( event :FaultEvent ) :Void {
      dispatchEvent( event );
   }

   private function handleError( event :ErrorEvent ) :Void {
      dispatchEvent( new FaultEvent( FaultEvent.FAULT, event.target, null,
         event.message ) );
   }

   private var m_xmlLoader :XmlLoader;
   private var m_request :Request;
}
