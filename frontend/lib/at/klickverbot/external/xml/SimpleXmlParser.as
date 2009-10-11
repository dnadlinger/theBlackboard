import at.klickverbot.core.CoreObject;

class at.klickverbot.external.xml.SimpleXmlParser extends CoreObject {
   public function parseXml( inputXml :XMLNode ) :Object {
      var result :Object;

      var nodeText :String = inputXml.firstChild.nodeValue;
      if ( nodeText == null ) {
         result = new Object();
         for ( var i :Number = 0; i < inputXml.childNodes.length; ++i ) {
            var currentNode :XMLNode = inputXml.childNodes[ i ];
            var parsedValue :Object = parseXml( currentNode );

            var presentValue :Object = result[ currentNode.nodeName ];
            if ( presentValue == null ) {
               result[ currentNode.nodeName ] = parsedValue;
            } else {
               if ( presentValue instanceof Array ) {
                  var presentNodes :Array = Array( presentValue );
                  presentNodes.push( parsedValue );
                  result[ currentNode.nodeName ] = presentNodes;
               } else {
                  result[ currentNode.nodeName ] = [ presentValue, parsedValue ];
               }
            }
         }
      } else {
         result = guessType( nodeText );
      }

      return result;
   }

   private function guessType( data :Object ) :Object {
      // TODO: Implement some kind of type guessing logic here.
      return data;
   }
}
