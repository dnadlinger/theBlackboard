import at.klickverbot.core.CoreObject;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.IClipFactory;
import at.klickverbot.ui.mouse.IMcCreator;

class at.klickverbot.ui.mouse.ClipFactoryMcCreator extends CoreObject
   implements IMcCreator {

   /**
    * Constructor.
    */
   public function ClipFactoryMcCreator( clipId :ClipId, clipFactory :IClipFactory ) {
      m_clipId = clipId;
      m_clipFactory = clipFactory;
   }

   public function createClip( target :MovieClip, name :String, depth :Number ) :MovieClip {
      return m_clipFactory.createClipById( m_clipId, target, name, depth );
   }

   public function getClipId() :ClipId {
      return m_clipId;
   }
   public function setClipId( newClipId :ClipId ) :Void {
      m_clipId = newClipId;
   }

   public function getClipFactory() :IClipFactory {
      return m_clipFactory;
   }
   public function setClipFactory( newClipFactory :IClipFactory ) :Void {
      m_clipFactory = newClipFactory;
   }

   private var m_clipId :ClipId;
   private var m_clipFactory :IClipFactory;
}
