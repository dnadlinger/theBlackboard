import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.tooltip.TooltipHandler;

class at.klickverbot.ui.tooltip.TooltipManager extends CoreObject {   /**     * Constructor.     * Private to allow no other instances.     */   private function TooltipManager() {
      m_targetClip = DEFAULT_TARGET;
      m_targetDepth = DEFAULT_DEPTH;
      m_activationDelay = DEFAULT_ACTIVATION_DELAY;
      m_fadeDuration = DEFAULT_FADE_DURATION;
      m_xMouseOffset = DEFAULT_X_MOUSE_OFFSET;
      m_yMouseOffset = DEFAULT_Y_MOUSE_OFFSET;

      m_handlers = new Array();   }

   /**    * Returns the only instance of the class.    *    * @return The instance of TooltipManager.    */   public static function getInstance() :TooltipManager {      if ( m_instance == null ) {         m_instance = new TooltipManager();      }      return m_instance;   }

   public function setTooltip( target :IUiComponent, tooltip :IUiComponent )
      :Void {

      if ( clearTooltip( target ) ) {
         Debug.LIBRARY_LOG.debug( "There is already a tooltip for the specified " +
            "target (" + target + "), replacing it with: " + tooltip );
      }

      var handler :TooltipHandler = new TooltipHandler( target, tooltip );
      m_handlers.push( handler );
   }

   public function clearTooltip( target :IUiComponent ) :Boolean {
      var currentHandler :TooltipHandler;
      var i :Number = m_handlers.length;
      while ( currentHandler = m_handlers[ --i ] ) {
         if ( currentHandler.getTarget() === target ) {
            currentHandler.detach();
            m_handlers.splice( i, 1 );
            return true;
         }
      }
      return false;
   }

   public function get targetClip() :MovieClip {
      return m_targetClip;
   }
   public function set targetClip( to :MovieClip ) :Void {
      m_targetClip = to;
   }

   public function get targetDepth() :Number {
      return m_targetDepth;
   }
   public function set targetDepth( to :Number ) :Void {
      m_targetDepth = to;
   }

   public function get activationDelay() :Number {
      return m_activationDelay;
   }
   public function set activationDelay( to :Number ) :Void {
      m_activationDelay = to;
   }

   public function get fadeDuration() :Number {
      return m_fadeDuration;
   }
   public function set fadeDuration( to :Number ) :Void {
      m_fadeDuration = to;
   }

   public function get xMouseOffset() :Number {
      return m_xMouseOffset;
   }
   public function set xMouseOffset( to :Number ) :Void {
      m_xMouseOffset = to;
   }

   public function get yMouseOffset() :Number {
      return m_yMouseOffset;
   }
   public function set yMouseOffset( to :Number ) :Void {
      m_yMouseOffset = to;
   }

   private static var DEFAULT_TARGET :MovieClip = _root;
   private static var DEFAULT_DEPTH :Number = 100;
   private static var DEFAULT_ACTIVATION_DELAY :Number = 1;
   private static var DEFAULT_FADE_DURATION :Number = 0.3;
   private static var DEFAULT_X_MOUSE_OFFSET :Number = 0;
   private static var DEFAULT_Y_MOUSE_OFFSET :Number = 20;

   private static var m_instance :TooltipManager;

   private var m_targetClip :MovieClip;
   private var m_targetDepth :Number;
   private var m_activationDelay :Number;
   private var m_fadeDuration :Number;
   private var m_xMouseOffset :Number;
   private var m_yMouseOffset :Number;

   private var m_handlers :Array;}