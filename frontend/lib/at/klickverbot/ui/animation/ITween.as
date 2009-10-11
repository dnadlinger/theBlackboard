import at.klickverbot.core.ICoreInterface;

/**
 * Represents any kind of tween.
 *
 */
interface at.klickverbot.ui.animation.ITween extends ICoreInterface {
   /**
    * Renders the tween at the specified point in time.
    *
    * @param time A floating point number which specifies the position
    *        between start (0) and end (1).
    */
   public function render( timeIndex :Number ) :Void;
}
