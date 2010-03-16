import at.klickverbot.theBlackboard.view.EntryViewEvent;
import at.klickverbot.ui.components.drawingArea.DrawingArea;
import at.klickverbot.drawing.Drawing;
import at.klickverbot.theBlackboard.view.DrawingAreaContainer;
import at.klickverbot.ui.components.data.IItemView;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.model.EntryChangeEvent;
import at.klickverbot.ui.components.CustomSizeableComponent;

class at.klickverbot.theBlackboard.view.EntryView extends CustomSizeableComponent
   implements IItemView {

   public function EntryView() {
      super();

      m_entry = null;
      m_drawingAreaContainer = new DrawingAreaContainer();
   }


   private function createUi() :Boolean {
      if( !super.createUi() ) {
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
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_drawingAreaContainer.resize( width, height );
   }

   public function getData() :Object {
      return m_entry;
   }

   public function setData( data :Object ) :Void {
      if ( m_entry == data ) {
         return;
      }

      if ( m_entry != null ) {
         removeModelListeners( m_entry );
      }
      m_entry = Entry( data );
      addModelListeners( m_entry );
      // TODO: Find a cleaner solution for loading the entry.
      // Maybe bubble the event up?
      dispatchEvent( new EntryViewEvent( EntryViewEvent.LOAD_ENTRY, this, m_entry ) );
      updateAll();
   }

   public function getDrawingArea() :DrawingArea {
      return m_drawingAreaContainer.getDrawingArea();
   }

   public function save() :Void {
      dispatchEvent( new EntryViewEvent( EntryViewEvent.SAVE_ENTRY, this, m_entry ) );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "entry: " + m_entry );
   }

   private function updateAll() :Void {
      updateDrawing( m_entry.drawing );
   }

   private function updateDrawing( drawing :Drawing ) :Void {
      if ( drawing == null ) {
         m_drawingAreaContainer.getDrawingArea().clearHistory();
      } else {
         m_drawingAreaContainer.getDrawingArea().loadDrawing( drawing );
      }
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
