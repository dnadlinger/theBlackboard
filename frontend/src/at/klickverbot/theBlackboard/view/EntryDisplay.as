import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.drawing.Drawing;
import at.klickverbot.theBlackboard.view.DrawingAreaContainer;
import at.klickverbot.theBlackboard.vo.Entry;
import at.klickverbot.theBlackboard.vo.EntryChangeEvent;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.theBlackboard.view.EntryDisplay extends CustomSizeableComponent
   implements IUiComponent {

   public function EntryDisplay() {
      super();

      m_entry = null;
      m_drawingAreaContainer = new DrawingAreaContainer();
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      if ( !super.create( target, depth ) ) {
         return false;
      }

      if ( !m_drawingAreaContainer.create( m_container ) ) {
         destroy();
         return false;
      }

      if ( m_entry ) {
         updateAll();
      }

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_drawingAreaContainer.destroy();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Attempted to resize an EntryDisplay that is not stage!" );
         return;
      }

      super.resize( width, height );
      m_drawingAreaContainer.resize( width, height );
   }

   public function getEntry() :Entry {
      return m_entry;
   }

   public function setEntry( entry :Entry ) :Void {
      if ( m_entry != null ) {
         removeModelListeners( m_entry );
      }
      m_entry = entry;
      addModelListeners( entry );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "entry: " + m_entry );
   }

   private function updateAll() :Void {
      updateDrawing( m_entry.drawing );
   }

   private function updateDrawing( drawing :Drawing ) :Void {
      // If there is no drawing set, we load an empty drawing.
      if ( drawing == null ) {
         drawing = new Drawing();
      }

      m_drawingAreaContainer.getDrawingArea().loadDrawing( drawing );
   }

   private function handleChange( event :EntryChangeEvent ) :Void {
      if ( event.type == EntryChangeEvent.DRAWING ) {
         updateDrawing( Drawing( event.newValue ) );
      }
   }

   private function addModelListeners( entry :Entry ) :Void {
      for ( var i :Number = 0; i < PROPERTY_EVENTS.length; ++i ) {
         entry.addEventListener( PROPERTY_EVENTS[ i ], this, handleChange );
      }
   }

   private function removeModelListeners( entry :Entry ) :Void {
      for ( var i :Number = 0; i < PROPERTY_EVENTS.length; ++i ) {
         entry.removeEventListener( PROPERTY_EVENTS[ i ], this, handleChange );
      }
   }

   private static var PROPERTY_EVENTS :Array = [
      EntryChangeEvent.ID,
      EntryChangeEvent.AUTHOR,
      EntryChangeEvent.CAPTION,
      EntryChangeEvent.DRAWING,
      EntryChangeEvent.TIMESTAMP,
      EntryChangeEvent.LOADED
   ];

   private var m_entry :Entry;
   private var m_drawingAreaContainer :DrawingAreaContainer;
}
