import at.klickverbot.core.CoreObject;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.mouse.IMcCreator;

class at.klickverbot.ui.mouse.ComponentPointerMapping extends CoreObject {
   /**
    * Constructor.
    */
   public function ComponentPointerMapping( component :IUiComponent,
      pointerCreator :IMcCreator, pointerTarget :MovieClip ) {
      m_component = component;
      m_pointerCreator = pointerCreator;
      m_pointerTarget = pointerTarget;
   }

   public function get component() :IUiComponent {
      return m_component;
   }
   public function set component( to :IUiComponent ) :Void {
      m_component = to;
   }

   public function get pointerCreator() :IMcCreator {
      return m_pointerCreator;
   }
   public function set pointerCreator( to :IMcCreator ) :Void {
      m_pointerCreator = to;
   }

   public function get pointerTarget() :MovieClip {
      return m_pointerTarget;
   }
   public function set pointerTarget( to :MovieClip ) :Void {
      m_pointerTarget = to;
   }

   private var m_component :IUiComponent;
   private var m_pointerCreator :IMcCreator;
   private var m_pointerTarget :MovieClip;
}
