import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.drawing.BezierOperation;
import at.klickverbot.drawing.BezierSegment2D;
import at.klickverbot.drawing.Drawing;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.LineOperation;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.graphics.Point2D;

class at.klickverbot.drawing.DrawingStringifier extends CoreObject {
   public function makeString( drawing :Drawing ) :String {
      var out :String = EXPORT_HEADER;

      var operations :Array = drawing.getOperations();

      var currentOp :IDrawingOperation;
      var tempStyle :LineStyle;

      var linePoints :Array;
      var tempPoint :Point2D;
      var tempSegments :Array;
      var tempSegment :BezierSegment2D;

      for ( var i :Number = 0; i < operations.length; ++i ) {
         currentOp = operations[ i ];
         out += DELIMITER_1;

         // TODO: Update stye export to reflect the switch from 0-100% to 0-1.
         tempStyle = currentOp.getStyle();
         out += tempStyle.thickness;
         out += DELIMITER_3;
         out += Math.round( tempStyle.color );
         out += DELIMITER_3;
         out += Math.round( tempStyle.alpha );
         out += DELIMITER_2;

         // Line operation export
         if ( currentOp instanceof LineOperation ) {
            linePoints = LineOperation( currentOp ).getPoints();
            out += LINE_ID;

            for ( var j :Number = 0; j < linePoints.length; ++j ) {
               tempPoint = Point2D( linePoints[ j ] );

               out += DELIMITER_2;
               out += Math.round( tempPoint.x );
               out += DELIMITER_3;
               out += Math.round( tempPoint.y );
            }
         }
         // Bézier operation export
         else if ( currentOp instanceof BezierOperation ) {
            tempPoint = BezierOperation( currentOp ).getStartPoint();
            tempSegments = BezierOperation( currentOp ).getSegments();

            out += BEZIER_ID;

            out += DELIMITER_2;

            out += tempPoint.x;
            out += DELIMITER_3;
            out += tempPoint.y;

            // TODO: Math.round here?
            for ( var j :Number = 0; j < tempSegments.length; ++j ) {
               tempSegment = tempSegment[ j ];
               out += DELIMITER_2;

               out += tempSegment.controlPoint.x;
               out += DELIMITER_4;
               out += tempSegment.controlPoint.y;
               out += DELIMITER_3;

               out += tempSegment.endPoint.x;
               out += DELIMITER_4;
               out += tempSegment.endPoint.y;
            }
         } else {
            Debug.LIBRARY_LOG.log( LogLevel.WARN,
               "Unsupported drawing operation, skipping..." );
         }
      }

      return out;
   }

   /**
    * Clears the current operations and parses the given
    * <code>drawingString</code>.
    */
   public function fromString( drawingString :String ) :Drawing {
      var drawing :Drawing = new Drawing();

      if ( ( drawingString == null ) || ( drawingString == "") ) {
         Debug.LIBRARY_LOG.warn( "Empty drawing string, returning empty drawing" );
         return drawing;
      }

      var opStrings :Array = drawingString.split( DELIMITER_1 );

      var header :String = String( opStrings.shift() );
      if ( header != EXPORT_HEADER ) {
         Debug.LIBRARY_LOG.log( LogLevel.ERROR,
            "Corrupt drawing string: Wrong header!" );
         return drawing;
      }

      var currentOpStrings :Array;
      var currentStyleStrings :Array;
      var opType :String;

      var tempOp :IDrawingOperation;
      var tempLineOp :LineOperation;
      var tempBezierOp :BezierOperation;
      var tempStyle :LineStyle;

      var currentSegmentStrings :Array;
      var currentPointStrings :Array;
      var tempSegment :BezierSegment2D;
      var tempPoint :Point2D;
      var tempControlPoint :Point2D;
      var tempEndPoint :Point2D;

      for ( var i :Number = 0; i < opStrings.length; ++i ) {
         currentOpStrings = opStrings[ i ].split( DELIMITER_2 );

         currentStyleStrings =
            String( currentOpStrings.shift() ).split( DELIMITER_3 );

         opType = String( currentOpStrings.shift() );

         // Line operation import.
         if ( opType == LINE_ID ) {
            tempLineOp = new LineOperation();
            tempOp = tempLineOp;

            for ( var j :Number = 0; j < currentOpStrings.length; ++j ) {
               currentPointStrings = currentOpStrings[ j ].split( DELIMITER_3 );
               tempPoint = new Point2D( Number( currentPointStrings[ 0 ] ),
                  Number( currentPointStrings[ 1 ] ) );

               tempLineOp.addPoint( tempPoint );
            }
         }
         // Bézier operation import.
         else if ( opType == BEZIER_ID ) {
            tempBezierOp = new BezierOperation();
            tempOp = tempBezierOp;

            currentPointStrings = currentOpStrings[ 0 ].split( DELIMITER_3 );
            tempBezierOp.setStartPoint( new Point2D(
               Number( currentPointStrings[ 0 ] ),
               Number( currentPointStrings[ 1 ] ) ) );

            for ( var j :Number = 1; j < currentOpStrings.length; ++j ) {
               currentSegmentStrings = currentOpStrings[ j ].split( DELIMITER_3 );

               currentPointStrings = currentSegmentStrings[ 1 ].split( DELIMITER_4 );
               tempControlPoint = new Point2D( Number( currentPointStrings[ 0 ] ),
                  Number( currentPointStrings[ 1 ] ) );

               currentPointStrings = currentSegmentStrings[ 2 ].split( DELIMITER_4 );
               tempEndPoint = new Point2D( Number( currentPointStrings[ 0 ] ),
                  Number( currentPointStrings[ 1 ] ) );


               tempSegment = new BezierSegment2D( tempControlPoint, tempEndPoint );
               tempBezierOp.addSegment( tempSegment );
            }
         }
         // Unsupported operation type.
         else {
            Debug.LIBRARY_LOG.log( LogLevel.ERROR,
               "Unsupported drawing operation type found!" );
            return drawing;
         }

         tempStyle = new LineStyle( Number( currentStyleStrings[ 0 ] ),
             Number( currentStyleStrings[ 1 ] ),  Number( currentStyleStrings[ 2 ] ) );
         tempOp.setStyle( tempStyle );

         drawing.addOperation( tempOp );
      }

      return drawing;
   }

   public static var EXPORT_HEADER :String = "D1";
   public static var LINE_ID :String = "l";
   public static var BEZIER_ID :String = "b";
   public static var DELIMITER_1 :String = "|";
   public static var DELIMITER_2 :String = ";";
   public static var DELIMITER_3 :String = ":";
   public static var DELIMITER_4 :String = ",";
}