
class at.klickverbot.external.xml.XmlStatusCodes {
   /**
    * Transforms the XML.status status code into a human-readable error message.
    * Code from: http://livedocs.adobe.com/flash/8/main/00002880.html.
    */
   public static function getMessageFromCode( status :Number ) :String {
      var errorMessage :String;
      switch ( status ) {
      case 0 :
         errorMessage = "No error; parse was completed successfully.";
         break;
      case -2 :
         errorMessage = "A CDATA section was not properly terminated.";
         break;
      case -3 :
         errorMessage = "The XML declaration was not properly terminated.";
         break;
      case -4 :
         errorMessage = "The DOCTYPE declaration was not properly terminated.";
         break;
      case -5 :
         errorMessage = "A comment was not properly terminated.";
         break;
      case -6 :
         errorMessage = "An XML element was malformed.";
         break;
      case -7 :
         errorMessage = "Out of memory.";
         break;
      case -8 :
         errorMessage = "An attribute value was not properly terminated.";
         break;
      case -9 :
         errorMessage = "A start-tag was not matched with an end-tag.";
         break;
      case -10 :
         errorMessage = "An end-tag was encountered without a matching " +
            "start-tag.";
         break;
      default :
         errorMessage = "An unknown error has occurred.";
         break;
      }
      return errorMessage;
   }
}