import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.external.xmlrpc.Data;
import at.klickverbot.external.xmlrpc.DataFormatter;
import at.klickverbot.external.xmlrpc.DataType;
import at.klickverbot.external.xmlrpc.TypeMapper;

class at.klickverbot.external.xmlrpc.Request extends CoreObject {
   /**
    * Constructor.
    */
   public function Request( methodName :String ) {
      m_methodName = methodName;
      m_typeMapper = new TypeMapper( DataType.INT, DataType.STRING );
      initXml();
   }

   public function addParam( newParam :Object ) :Boolean {
      var paramNode :XMLNode = createParamNode( newParam );
      if ( paramNode == null ) {
         return false;
      }

      m_paramsNode.appendChild( paramNode );
      return true;
   }

   public function addParams( paramArray :Array ) :Boolean {
      for ( var i :Number = 0; i < paramArray.length; ++i ) {
         if ( !addParam( paramArray[ i ] ) ) {
            removeAllParams();
            return false;
         }
      }
      return true;
   }

   public function removeAllParams() :Void {
      var paramNodes :Array = m_paramsNode.childNodes;
      for ( var i :Number = 0; i < paramNodes.length; ++i ) {
         XMLNode( paramNodes[ i ] ).removeNode();
      }
   }

   public function getXmlData() :XML {
      // We cannot just return m_xmlData here because it would only be a
      // reference to the interal XML object and not a deep copy. Unfortunately
      // XML itself has no clone()-method, so we have to clone the root node and
      // append it to the new XML.
      var clonedData :XML = new XML();
      clonedData.xmlDecl = '<?xml version="1.0"?>';
      clonedData.contentType = "text/xml";
      clonedData.appendChild( m_xmlData.firstChild.cloneNode( true ) );
      return clonedData;
   }

   public function getMethodName() :String {
      return m_methodName;
   }

   private function initXml() :Void {
      m_xmlData = new XML();

      var rootNode :XMLNode = m_xmlData.createElement( "methodCall" );
      m_xmlData.appendChild( rootNode );

      var methodNameNode :XMLNode = m_xmlData.createElement( "methodName" );
      methodNameNode.appendChild( m_xmlData.createTextNode( m_methodName ) );
      rootNode.appendChild( methodNameNode );

      m_paramsNode = m_xmlData.createElement( "params" );
      rootNode.appendChild( m_paramsNode );
   }

   private function createParamNode( param :Object ) :XMLNode {
      if ( param == null ) {
         Debug.LIBRARY_LOG.warn( "Attempted to add null, which is not allowed " +
            "in XML-RPC, as a parameter to " + this );
         return null;
      }

      var paramNode :XMLNode = m_xmlData.createElement( "param" );

      var paramData :Data = dataFromObject( param );
      var valueNode :XMLNode = createValueNode( paramData );

      if ( valueNode == null ) {
         return null;
      }
      paramNode.appendChild( valueNode );

      return paramNode;
   }

   private function createValueNode( data :Data ) :XMLNode {
      var valueNode :XMLNode = null;

      if ( data.type == DataType.COMPLEX_TYPE_STRUCT ) {
         valueNode = createStructValueNode( data );
      } else if ( data.type == DataType.COMPLEX_TYPE_ARRAY ) {
         valueNode = createArrayValueNode( data );
      } else if ( m_typeMapper.isSimpleType( data.type ) ) {
         valueNode = createSimpleValueNode( data );
      }

      return valueNode;
   }

   private function createStructValueNode( inputData :Data ) :XMLNode {
      Debug.assertEqual( inputData.type, DataType.COMPLEX_TYPE_STRUCT,
         "Cannot createStructValueNode() for non-struct DataType!" );
      Debug.assertEqual( typeof( inputData.value ), "object",
         "Data value must be typeof object for createStructValueNode()!" );

      var valueNode :XMLNode = m_xmlData.createElement( "value" );
      var structNode :XMLNode = m_xmlData.createElement( "struct" );

      var memberNode :XMLNode;

      var currentMember :Object;
      for ( var currentKey :String in inputData.value ) {
         currentMember = inputData.value[ currentKey ];
         memberNode = m_xmlData.createElement( "member" );

         var memberData :Data = dataFromObject( currentMember );
         var memberValueNode :XMLNode = createValueNode( memberData );
         if ( memberValueNode == null ) {
            return null;
         }

         var memberNameNode :XMLNode = m_xmlData.createElement( "name" );
         memberNameNode.appendChild( m_xmlData.createTextNode( currentKey ) );
         memberNode.appendChild( memberNameNode );

         memberNode.appendChild( memberValueNode );

         structNode.appendChild( memberNode );
      }

      valueNode.appendChild( structNode );
      return valueNode;
   }

   private function createArrayValueNode( inputData :Data ) :XMLNode {
      Debug.assertEqual( inputData.type, DataType.COMPLEX_TYPE_ARRAY,
         "Cannot createArrayValueNode() for non-array DataType!" );
      Debug.assertInstanceOf( inputData.value, Array,
         "Data value must be instanceof Array for createArrayValueNode()!" );

      var valueNode :XMLNode = m_xmlData.createElement( "value" );
      var arrayNode :XMLNode = m_xmlData.createElement( "array" );
      var dataNode :XMLNode = m_xmlData.createElement( "data" );

      var inputArray :Array = Array( inputData.value );
      var currentData :Data;
      for ( var i :Number = 0; i < inputArray.length; ++i ) {
         currentData = dataFromObject( inputArray[ i ] );

         var elementValueNode :XMLNode = createValueNode( currentData );
         if ( elementValueNode == null ) {
            return null;
         }
         dataNode.appendChild( elementValueNode );
      }

      arrayNode.appendChild( dataNode );
      valueNode.appendChild( arrayNode );
      return valueNode;
   }

   private function createSimpleValueNode( data :Data ) :XMLNode {
      var valueNode :XMLNode = m_xmlData.createElement( "value" );

      var typeNode :XMLNode = m_xmlData.createElement( data.type.getName() );
      typeNode.appendChild( m_xmlData.createTextNode(
         DataFormatter.dataValueToString( data.value, data.type ) ) );

      valueNode.appendChild( typeNode );
      return valueNode;
   }

   private function dataFromObject( object :Object ) :Data {
      var data :Data;
      if ( object instanceof Data ) {
         data = Data( object );
      } else {
         data = new Data( object, m_typeMapper.getDataType( object ) );
      }
      return data;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "methodName: " + m_methodName );
   }

   private var m_methodName :String;

   private var m_xmlData :XML;
   private var m_paramsNode :XMLNode;

   private var m_typeMapper :TypeMapper;
}
