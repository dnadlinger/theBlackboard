import at.klickverbot.core.ICoreInterface;

interface at.klickverbot.ui.mouse.IMcCreator extends ICoreInterface {
   public function createClip( target :MovieClip, name :String, depth :Number ) :MovieClip;
}
