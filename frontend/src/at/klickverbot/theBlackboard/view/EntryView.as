import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.model.EntryChangeEvent;
import at.klickverbot.theBlackboard.view.DrawingAreaContainer;
import at.klickverbot.theBlackboard.view.EntryTooltip;
import at.klickverbot.theBlackboard.view.event.EntryViewEvent;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Stack;
import at.klickverbot.ui.components.data.IItemView;
import at.klickverbot.ui.components.drawingArea.DrawingArea;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.tooltip.TooltipManager;

/**
 * An ItemView displaying a single entry.
 */
class at.klickverbot.theBlackboard.view.EntryView extends CustomSizeableComponent
   implements IItemView {

   public function EntryView() {
      super();

      m_entry = null;

      m_loadingIndicator = new Static( AppClipId.ENTRY_LOADING_INDICATOR );
      m_drawingAreaContainer = new DrawingAreaContainer();

      m_displayStack = new Stack();
      m_displayStack.addContent( m_loadingIndicator );
      m_displayStack.addContent( m_drawingAreaContainer );
      m_displayStack.selectComponent( null );
   }


   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_displayStack.create( m_container ) ) {
         destroy();
         return false;
      }

      if ( m_entry ) {
         loadCurrentEntry();
      }

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_displayStack.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_displayStack.resize( width, height );
   }

   public function getData() :Object {
      return m_entry;
   }

   public function setData( data :Object ) :Void {
      if ( m_entry == data ) {
         // Nothing to do, return early to circumvent expensive drawing loading.
         return;
      }

      if ( m_entry != null ) {
         // We are not interested in the old entry being loaded anymore.
         m_entry.removeEventListener( EntryChangeEvent.LOADED,
            this, displayCurrentEntry );
      }

      m_entry = Entry( data );
      loadCurrentEntry();
   }

   /**
    * Returns a reference to the child DrawingArea used for displaying the
    * entry.
    */
   public function getDrawingArea() :DrawingArea {
      return m_drawingAreaContainer.getDrawingArea();
   }

   /**
    * Save the entry associated with this view.
    * 
    * As well as #getDrawingArea, this being called externally is a design
    * kludge, but for smooth operation, the same component needs to be used for
    * creating an entry and for showing it afterwards.
    */
   public function save() :Void {
      // When the entry has been saved to the backend, set the tooltip.
      m_entry.addEventListener( EntryChangeEvent.DIRTY, this, registerTooltip );
 
      dispatchEvent(
         new EntryViewEvent( EntryViewEvent.SAVE_ENTRY, this, m_entry ) );
   }

   private function loadCurrentEntry() :Void {
      if ( !m_onStage ) {
         return;
      }

      TooltipManager.getInstance().clearTooltip( this );

      if ( m_entry == null ) {
         m_displayStack.selectComponent( null );
         return;
      }

      if ( m_entry.loaded || !m_entry.isPesistent() ) {
         displayCurrentEntry();
      } else {
         m_displayStack.selectComponent( m_loadingIndicator );

         m_entry.addEventListener( EntryChangeEvent.LOADED, this, displayCurrentEntry );
         dispatchEvent(
            new EntryViewEvent( EntryViewEvent.LOAD_ENTRY, this, m_entry ) );
      }
   }

   private function displayCurrentEntry() :Void {
      m_drawingAreaContainer.getDrawingArea().loadDrawing( m_entry.drawing );

      if ( m_entry.isPesistent() ) {
         // Avoid displaying a tooltip with "null" contents when creating a new
         // entry.
         registerTooltip();
      }

      m_displayStack.selectComponent( m_drawingAreaContainer );
   }

   private function registerTooltip() :Void {
   	TooltipManager.getInstance().setTooltip( this, new EntryTooltip( m_entry ) );
   }

   
   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "entry: " + m_entry );
   }

   private var m_entry :Entry;
   private var m_displayStack :Stack;
   private var m_drawingAreaContainer :DrawingAreaContainer;
   private var m_loadingIndicator :Static;
}
