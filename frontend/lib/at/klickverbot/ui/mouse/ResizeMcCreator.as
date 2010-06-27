import at.klickverbot.core.CoreObject;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.mouse.IMcCreator;

class at.klickverbot.ui.mouse.ResizeMcCreator extends CoreObject
   implements IMcCreator {

   public function ResizeMcCreator( wrappedCreator :IMcCreator, targetSize :Point2D ) {
      m_wrapped = wrappedCreator;
      m_targetSize = targetSize;
   }

   public function createClip( target :MovieClip, name :String, depth :Number )
      :MovieClip {

      var clip :MovieClip = m_wrapped.createClip( target, name, depth );

      clip._width = m_targetSize.x;
      clip._height = m_targetSize.y;

      return clip;
   }

   private var m_wrapped :IMcCreator;
   private var m_targetSize :Point2D;
}
