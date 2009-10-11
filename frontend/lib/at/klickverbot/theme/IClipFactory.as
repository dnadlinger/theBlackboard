import at.klickverbot.core.ICoreInterface;
import at.klickverbot.theme.ClipId;

/**
 * Represents a class that can create various MovieClips at a custom place
 * using ClipIds to determine which MovieClip is created.
 *
 */
interface at.klickverbot.theme.IClipFactory extends ICoreInterface {
   /**
    * Creates the MovieClip that is specified with the clipId in the target
    * MovieClip.
    *
    * @param clipId A ClipId specifying which MovieClip to create.
    * @param target The MovieClip where the instance is created.
    * @param name The name of the created instance.
    * @param depth The depth at which the MovieClip is created in the target.
    */
   public function createClipById( clipId :ClipId, target :MovieClip, name :String,
      depth :Number ) :MovieClip;
}