import at.klickverbot.core.ICoreInterface;

interface at.klickverbot.ui.animation.timeMapping.ITimeMapper
   extends ICoreInterface {

   /**
    * @param timeIndex The position in time from start (0) to end (1).
    * @return The position in time from start (0) to end (1).
    */
   public function map( timeIndex :Number ) :Number;
}