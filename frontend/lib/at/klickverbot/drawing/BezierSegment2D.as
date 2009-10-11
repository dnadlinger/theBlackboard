import at.klickverbot.core.CoreObject;
import at.klickverbot.drawing.Point2D;

class at.klickverbot.drawing.BezierSegment2D extends CoreObject {
   /**
    * Constructor.
    */
   public function BezierSegment2D( controlPoint :Point2D, endPoint :Point2D ) {
      m_controlPoint = controlPoint;
      m_endPoint = endPoint;
   }

   public function get controlPoint() :Point2D {
      return m_controlPoint;
   }
   public function set controlPoint( to :Point2D ) :Void {
      m_controlPoint = to;
   }

   public function get endPoint() :Point2D {
      return m_endPoint;
   }
   public function set endPoint( to :Point2D ) :Void {
      m_endPoint = to;
   }

   /**
    * Creates a copy of this object.
    *
    * @param deep Speciefies if a shallow or a deep copy will be created.
    *        Defaults to true.
    * @return The copied object.
    */
   public function clone( deep :Boolean ) :BezierSegment2D {
      if ( deep == null ) {
         deep = true;
      }

      if ( deep ) {
         return new BezierSegment2D(
            m_controlPoint.clone(),
            m_endPoint.clone()
         );
      } else {
         return new BezierSegment2D(
            m_controlPoint,
            m_endPoint
         );
      }
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "controlPoint: " + m_controlPoint,
         "endPoint: " + m_endPoint
      ] );
   }

   private var m_controlPoint :Point2D;
   private var m_endPoint :Point2D;
}