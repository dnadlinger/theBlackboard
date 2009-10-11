import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.external.xml.XmlNodeTypes;
import at.klickverbot.external.xmlrpc.DataFormatter;
import at.klickverbot.external.xmlrpc.DataType;
import at.klickverbot.external.xmlrpc.MethodFault;
import at.klickverbot.external.xmlrpc.TypeMapper;

class at.klickverbot.external.xmlrpc.Response extends CoreObject {
   /**
    * Constructor.
    */
   public function Response() {
      m_isFault = false;
      m_returnValue = null;
      m_methodFault = null;

      m_typeMapper = new TypeMapper();
   }

   public function parseResponse( responseXml :XMLNode ) :Boolean {
      var methodResponseNode :XMLNode = responseXml.firstChild;

      if ( methodResponseNode.nodeName != "methodResponse" ) {
         logInvalidResponse( "The root node must be <methodResponse>" );
         return false;
      }

      if ( methodResponseNode.childNodes.length != 1 ) {
         logInvalidResponse( "<methodResponse> must contain exactly one child node " +
            "(<params> or <fault>)" );
         return false;
      }

      var typeNode :XMLNode = methodResponseNode.firstChild;
      var typeNodeName :String = typeNode.nodeName;
      if ( typeNodeName == "params" ) {
         return parseParams( typeNode );
      } else if ( typeNodeName == "fault" ) {
         return parseFault( typeNode );
      } else {
         logInvalidResponse( "<methodResponse> must have a <params> or <fault> " +
            "child node and cannot have a <" + typeNodeName + "> child" );
         return false;
      }
   }

   public function isFault() :Boolean {
      if ( !checkIfAlreadyParsed() ) {
         return null;
      }
      return m_isFault;
   }

   public function getFault() :MethodFault {
      if ( !checkIfAlreadyParsed() ) {
         return null;
      }
      if ( !m_isFault ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "Attempted to use getFault() " +
            "on a non-fault xmlrpc response" );
         return null;
      }
      return m_methodFault;
   }

   public function getReturnValue() :Object {
      if ( !checkIfAlreadyParsed() ) {
         return null;
      }
      if ( m_isFault ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "Attempted to use " +
            "getReturnValue() on a faulty xmlrpc response" );
         return null;
      }
      return m_returnValue;
   }

   private function parseParams( paramsNode :XMLNode ) :Boolean {
      if ( paramsNode.childNodes.length != 1 ) {
         logInvalidResponse( "<params> must contain exactly one <param> node" );
      }

      var paramNode :XMLNode = paramsNode.firstChild;
      var valueNode :XMLNode;
      if ( paramNode.nodeName != "param" ) {
         logInvalidResponse( "Invalid <params> child node, must be <param>: " +
            "<" + paramNode.nodeName + ">" );
         return false;
      }

      valueNode = paramNode.firstChild;
      if ( valueNode.nodeName != "value" ) {
         logInvalidResponse( "Invalid <param> child node, must be <value>: " +
            "<" + valueNode.nodeName + ">" );
         return false;
      }

      var paramObject :Object = parseValue( valueNode );
      if ( paramObject == null ) {
         logInvalidResponse( "Error while parsing value node" );
         return false;
      }

      m_returnValue = paramObject;
      return true;
   }

   private function parseFault( faultNode :XMLNode ) :Boolean {
      if ( ( faultNode.childNodes.length != 1 ) ) {
         logInvalidResponse( "<fault> must contain exactly one <value> node" );
         return false;
      }

      var valueNode :XMLNode = faultNode.firstChild;
      if ( valueNode.nodeName != "value" ) {
         logInvalidResponse( "<fault> must contain exactly one <value> node" );
         return false;
      }

      var faultObject :Object = parseValue( valueNode );
      if ( faultObject == null ) {
         logInvalidResponse( "Error while parsing fault value" );
         return false;
      }

      var faultCode :Number = faultObject[ "faultCode" ];
      if ( faultCode == null ) {
         logInvalidResponse( "<fault> must contain a valid <faultCode> node" );
         return false;
      }

      var faultString :String = faultObject[ "faultString" ];
      if ( faultString == null ) {
         logInvalidResponse( "<fault> must contain a valid <faultString> node" );
         return false;
      }

      m_methodFault = new MethodFault( faultCode, faultString );
      m_isFault = true;
      return true;
   }

   private function parseValue( valueNode :XMLNode ) :Object {
      // The xmlrpc spec states: If no type is indicated, the type is string.
      // Hence check for the type of the firstChild of value node. If it is an
      // element node, the type is specified, if not, default to string.
      var typeNode :XMLNode = valueNode.firstChild;

      var dataType :DataType;
      var dataContainingNode :XMLNode;

      if ( typeNode.nodeType == XmlNodeTypes.ELEMENT_NODE ) {
         var typeString :String = typeNode.nodeName;

         dataType = m_typeMapper.getTypeFromString( typeString );
         if ( dataType == null ) {
            logInvalidResponse( "<" + typeString + "> is not an allowed type" );
            return null;
         }
         dataContainingNode = typeNode;
      } else {
         dataType = DataType.STRING;
         dataContainingNode = valueNode;
      }


      var resultObject :Object = null;

      if ( dataType == DataType.COMPLEX_TYPE_STRUCT ) {
         resultObject = new Object();

         var currentMemberNode :XMLNode;
         var currentNameNode :XMLNode;
         var currentValueNode :XMLNode;

         var currentName :String;
         var currentValueObject :Object;

         var memberNodes :Array = dataContainingNode.childNodes;
         for ( var i :Number = 0; i < memberNodes.length; ++i ) {
            currentMemberNode = memberNodes[ i ];

            if ( currentMemberNode.nodeName != "member" ) {
               logInvalidResponse( "<struct> can only contain <member> nodes" );
               return null;
            }

            currentNameNode = findXmlNode( currentMemberNode, "name" );
            if ( currentNameNode == null ) {
               logInvalidResponse( "<member> must contain a <name> node" );
               return null;
            }

            currentName = currentNameNode.firstChild.nodeValue;
            if ( !( 0 < currentName.length ) ) {
               logInvalidResponse( "struct member <name> must be at least one" +
                  "character" );
               return null;
            }

            currentValueNode = findXmlNode( currentMemberNode, "value" );
            if ( currentValueNode == null ) {
               logInvalidResponse( "<member> must contain a <value> node" );
               return null;
            }

            currentValueObject = parseValue( currentValueNode );
            if ( currentValueObject == null ) {
               logInvalidResponse( "Error parsing struct member value" );
               return null;
            }

            resultObject[ currentName ] = currentValueObject;
         }
      } else if ( dataType == DataType.COMPLEX_TYPE_ARRAY ) {
         var dataNode :XMLNode = dataContainingNode.firstChild;
         if ( dataNode.nodeName != "data" ) {
            logInvalidResponse( "<array> must contain exactly one <data> node!" );
            return null;
         }

         var resultArray :Array = new Array();

         var currentValueNode :XMLNode;
         var currentValueObject :Object;

         var valueNodes :Array = dataNode.childNodes;
         for ( var i :Number = 0; i < valueNodes.length; ++i ) {
            currentValueNode = valueNodes[ i ];
            if ( currentValueNode.nodeName != "value" ) {
               logInvalidResponse( "Invalid array <data> child, must be <value>: " +
               currentValueNode.nodeName );
            }

            currentValueObject = parseValue( currentValueNode );
            if ( currentValueObject == null ) {
               logInvalidResponse( "Error parsing array data value" );
               return null;
            }
            resultArray.push( currentValueObject );
         }
         resultObject = resultArray;
      } else if ( m_typeMapper.isSimpleType( dataType ) ) {
         var dataString :String = dataContainingNode.firstChild.nodeValue;
         if ( !( 0 < dataString.length ) ) {
            logInvalidResponse( "Value data must not be empty" );
            return null;
         }
         resultObject = DataFormatter.stringToDataValue( dataString, dataType );
      }

      return resultObject;
   }

   private function findXmlNode( parent :XMLNode, name :String ) :XMLNode {
      var nodes :Array = parent.childNodes;
      var currentNode :XMLNode;
      for ( var i :Number = 0; i < nodes.length; ++i ) {
         currentNode = nodes[ i ];
         if ( currentNode.nodeName == name ) {
            return currentNode;
         }
      }
      return null;
   }

   private function checkIfAlreadyParsed() :Boolean {
      if( ( m_returnValue == null ) && ( !m_isFault ) ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "No response parsed yet!" );
         return false;
      } else {
         return true;
      }
   }

   private function logInvalidResponse( reason :String ) :Void {
      Debug.LIBRARY_LOG.warn( "Invalid xmlrpc response: " + reason );
   }

   private var m_returnValue :Object;
   private var m_isFault :Boolean;
   private var m_methodFault :MethodFault;

   private var m_typeMapper :TypeMapper;
}