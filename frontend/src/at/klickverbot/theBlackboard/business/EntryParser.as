import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.debug.Logger;
import at.klickverbot.drawing.DrawingStringifier;
import at.klickverbot.theBlackboard.vo.Entry;

class at.klickverbot.theBlackboard.business.EntryParser extends CoreObject {
   public function parseEntry( source :Object ) :Entry {
      var result :Entry = new Entry();

      // TODO: Validity checks here!
      result.id = source[ "id" ];
      if ( result.id == null ) {
         Logger.getLog( "EntryLoader" ).log( LogLevel.WARN,
            "Id is missing in the object recieved from the server." );
         return null;
      }

      result.author = source[ "author" ];
      if ( result.author == null ) {
         Logger.getLog( "EntryLoader" ).log( LogLevel.WARN,
            "Author is missing in the object recieved from the server." );
         return null;
      }

      result.caption = source[ "caption" ];
      if ( result.caption == null ) {
         Logger.getLog( "EntryLoader" ).log( LogLevel.WARN,
            "Caption is missing in the object recieved from the server." );
         return null;
      }

      var drawingString :String = source[ "drawingString" ];
      if ( drawingString == null ) {
         Logger.getLog( "EntryLoader" ).log( LogLevel.WARN,
            "Drawing string is missing in the object recieved from the server." );
         return null;
      }

      var stringifier :DrawingStringifier = new DrawingStringifier();
      result.drawing = stringifier.fromString( drawingString );

      var unixTimestamp :Number = Number( source[ "timestamp" ] );
      if ( isNaN( unixTimestamp ) ) {
         Logger.getLog( "EntryLoader" ).log( LogLevel.WARN,
            "Invalid timestamp in the object recieved from the server." );
         return null;
      }
      var date :Date = new Date();
      date.setTime( unixTimestamp * 1000 );
      result.timestamp = date;

      result.loaded = true;

      return result;
   }
}
