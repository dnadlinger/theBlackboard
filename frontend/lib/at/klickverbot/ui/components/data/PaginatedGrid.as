import at.klickverbot.data.List;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.Logger;
import at.klickverbot.event.events.CollectionEvent;
import at.klickverbot.theBlackboard.view.EntryView;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.Grid;
import at.klickverbot.ui.components.data.IItemView;
import at.klickverbot.ui.components.data.IItemViewFactory;
import at.klickverbot.ui.components.data.IPaginated;
import at.klickverbot.ui.components.data.PaginatedChangeEvent;
import at.klickverbot.ui.components.data.PaginatedModel;

class at.klickverbot.ui.components.data.PaginatedGrid
   extends CustomSizeableComponent implements IPaginated {

   public function PaginatedGrid( items :List, itemViewFactory :IItemViewFactory,
      columnWidth :Number, rowHeight :Number ) {

      super();

      m_items = items;
      m_itemViewFactory = itemViewFactory;
      m_itemViews = new Array();
      m_grid = new Grid( columnWidth, rowHeight );
      m_currentStartOffset = 0;

      // Use an internal PaginatedModel to notify listeners of changes as
      // required by IPaginated.
      m_paginatedModel = new PaginatedModel( 0, 0 );
      m_paginatedModel.addEventListener( PaginatedChangeEvent.PAGE_COUNT,
         this, dispatchEvent );
      m_paginatedModel.addEventListener( PaginatedChangeEvent.CURRENT_PAGE,
         this, dispatchEvent );
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_grid.create( m_container ) ) {
         return false;
      }

      m_items.addEventListener( CollectionEvent.CHANGE, this, updatePage );
      m_items.addEventListener( CollectionEvent.CHANGE,
         this, updateItemViewData );

      // There were no item views up to now, so use zero for oldCapacity.
      updateGridContents( 0 );
      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_grid.destroy();
         if ( m_itemViews.length > 0 ) {
            m_itemViews = new Array();
         }

         m_items.removeEventListener( CollectionEvent.CHANGE,
            this, updateItemViewData );
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      m_grid.resize( width, height );
      updateGridContents();
      updatePage();
   }

   public function getCurrentPage() :Number {
      return m_paginatedModel.currentPage;
   }

   public function getPageCount() :Number {
      return m_paginatedModel.pageCount;
   }

   public function goToPreviousPage() :Void {
      var newStartOffset :Number = m_currentStartOffset - m_grid.getCapacity();
      Debug.assertPositive( newStartOffset,
         "Not enough items in the grid to go to the previous page: " + this );

      setStartOffset( newStartOffset );
      updateItemViewData();
   }

   public function goToNextPage() :Void {
      var newStartOffset :Number = m_currentStartOffset + m_grid.getCapacity();
      Debug.assertLess( newStartOffset, m_items.getLength(),
         "Not enough items in the grid to go to the next page: " + this );

      setStartOffset( newStartOffset );
      updateItemViewData();
   }

   public function goToFirstPage() :Void {
      setStartOffset( 0 );
      updateItemViewData();
   }

   public function goToLastPage() :Void {
      setStartOffset( ( getPageCount() - 1 ) * m_grid.getCapacity() );
      updateItemViewData();
   }

   public function getViewForItem( item :Object ) :IItemView {
      var itemView :IItemView;

      for ( var i :Number = 0; i < m_itemViews.length ; ++i ) {
         var currentDisplay :EntryView = m_itemViews[ i ];
         if ( currentDisplay.getData() == item ) {
            itemView = currentDisplay;
            break;
         }
      }

      if ( itemView == null ) {
         Logger.getLog( "PaginatedGrid" ).warn(
            "The item whose view was requested is currently not on stage." );
      }

      return itemView;
   }

   private function updatePage() :Void {
      m_paginatedModel.pageCount =
         Math.ceil( m_items.getLength() / m_grid.getCapacity() );

      var newPage :Number = Math.min( getCurrentPage(), getPageCount() );
      setStartOffset( newPage * m_grid.getCapacity() );
   }

   private function updateGridContents() :Void {
      // If the new capacity is larger than it was ever before, create new
      // item views for it. Don't care to remove surplus ones, they are not
      // put on stage anyway.
      var newViewsNeeded :Number = m_grid.getCapacity() - m_itemViews.length;
      for ( var i :Number = 0; i < newViewsNeeded; ++i ) {
         var newView :IItemView = m_itemViewFactory.createItemView();
         m_itemViews.push( newView );
         m_grid.addContent( newView );
      }

      updateItemViewData();
   }

   private function updateItemViewData() :Void {
      Debug.assert( m_onStage,
        "updateItemViewData called for an instance not on stage: " + this );

      var currentView :IItemView;
      var i :Number = m_itemViews.length;
      while ( currentView = m_itemViews[ --i ] ) {
         var data :Object = null;

         if ( i < ( m_items.getLength() - m_currentStartOffset ) ) {
            data = m_items.getItemAt( m_currentStartOffset + i );
         }

         currentView.setData( data );
      }
   }

   private function setStartOffset( newOffset :Number ) :Void {
      m_currentStartOffset = newOffset;
      m_paginatedModel.currentPage =
         Math.floor( m_currentStartOffset / m_grid.getCapacity() );
   }

   private var m_items :List;
   private var m_itemViewFactory :IItemViewFactory;
   private var m_itemViews :Array;
   private var m_grid :Grid;
   private var m_currentStartOffset :Number;
   private var m_paginatedModel :PaginatedModel;
}
