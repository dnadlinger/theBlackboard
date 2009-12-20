import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.ScaleGridContent;
import at.klickverbot.ui.layout.HorizontalPosition;
import at.klickverbot.ui.layout.ScaleGridCell;
import at.klickverbot.ui.layout.VerticalPosition;

/**
 * A container which provides resizing behavior similar to the nine-slice
 * scaling feature in the Flash IDE.
 *
 * The detailled semantics of this class are a bit hard to understand, but
 * enbale several powerful use cases: All that this class assumes about its
 * children resp. content components is that the coordinate systems that this
 * class and the content component were created in are equal.
 *
 * This is obviously the case for »normal« components which are created in the
 * target container MovieClip when their create method is called. But the
 * loose restrictions make it also possible to use MovieClips which are already
 * on stage (e.g. because they are part of a library symbol) by wrapping them
 * with a McWrapperComponent.
 *
 * Moreover, the algorithms used in this class are designed so that a MovieClip
 * in a specific cell does not even have to fit inside the area of that cell (as
 * defined by the four width/height values) to be scaled/moved in a reasonable
 * way. However, please be aware that content extending beyond the bottom right
 * corner could lead to strange resizing behavior (the size reported by
 * getSize() and the size of the space occupied in the parent MovieClip would
 * differ).
 */
class at.klickverbot.ui.components.ScaleGrid extends CustomSizeableComponent
   implements IUiComponent {

   /**
    * Constructor.
    */
   public function ScaleGrid() {
      super();

      m_contents = new Array();

      m_leftWidth = 0;
      m_rightWidth = 0;
      m_topHeight = 0;
      m_bottomHeight = 0;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      var currentContent :ScaleGridContent;
      var i :Number = m_contents.length;
      while ( currentContent = m_contents[ --i ] ) {
          if ( !currentContent.component.create( m_container ) ) {
            Debug.LIBRARY_LOG.error( "Could not create the component " +
               currentContent.component + " for the container element " +
               currentContent.cell );
            destroy();
            return false;
         }
      }

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         var currentContent :ScaleGridContent;
         var i :Number = m_contents.length;

         while ( currentContent = m_contents[ --i ] ) {
            // Check if the components are on stage before destorying them. Not
            // doing so could result destroy() being called two times if the UI
            // is destroyed because a child of this container could not be
            // created.
            if ( currentContent.component.isOnStage() ) {
               currentContent.component.destroy();
            }
         }
      }

      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Attempted to resize a ScaleGrid " +
            "that is not on stage." );
         return;
      }

      var oldSize :Point2D = getSize();

      // Calculate the scaling factors for the center row and column.
      var outerWidth :Number = m_leftWidth + m_rightWidth;
      var oldCenterWidth :Number = oldSize.x - outerWidth;
      var newCenterWidth :Number = oldCenterWidth + ( width - oldSize.x );

      var outerHeight :Number = m_topHeight + m_bottomHeight;
      var oldCenterHeight :Number = oldSize.y - outerHeight;
      var newCenterHeight :Number = oldCenterHeight + ( height - oldSize.y );

      if ( ( newCenterWidth < 0 ) || ( newCenterHeight < 0 ) ) {
         // TODO: Implement a more sophisticated fallback (maybe resizing m_container?).
         Debug.LIBRARY_LOG.warn( "Could not resize the ScaleGrid because the" +
            "target size (" + width + ", " + height + ") is smaller than the" +
            "limits resulting from the set cell sizes (" + outerWidth +
            ", " + outerHeight + "): " + this );
         return;
      }

      // Resize and/or move each content component according to its position
      // in the scale grid. We have to treat all components in one cell as if
      // the cell was a single unit, so we also have to move them accordingly
      // to reflect the process in an imaginary single cell.
      var currentContent :ScaleGridContent;
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         currentContent = m_contents[ i ];

         var position :Point2D = currentContent.component.getPosition();
         var size :Point2D = currentContent.component.getSize();

         // If the component is in the middle column, it is scaled along
         // the x axis.
         // If the component is in the right column, it is moved along the x
         // axis.
         if ( currentContent.cell.column == HorizontalPosition.CENTER ) {
            if ( oldCenterWidth > 0 ) {
               var xScaleFactor :Number = newCenterWidth / oldCenterWidth;
               size.x *= xScaleFactor;
               position.x += ( xScaleFactor - 1 )  * ( position.x - m_leftWidth );
            } else {
               size.x = newCenterWidth;
               position.x = m_leftWidth;
            }
         } else if ( currentContent.cell.row == HorizontalPosition.RIGHT ) {
            position.x += width - oldSize.x;
         }

         // If the component is in the middle *row*, it is scaled along the
         // y axis.
         // If the component is in the bottom row, it is moved along the y
         // axis.
         if ( currentContent.cell.row == VerticalPosition.MIDDLE ) {
            if ( oldCenterHeight > 0 ) {
               var yScaleFactor :Number = newCenterHeight / oldCenterHeight;
               size.y *= yScaleFactor;
               position.y += ( yScaleFactor - 1 )  * ( position.y - m_topHeight );
            } else {
               size.y = newCenterHeight;
               position.y = m_topHeight;
            }
         } else if ( currentContent.cell.row == VerticalPosition.BOTTOM ) {
            position.y += height - oldSize.y;
         }

         currentContent.component.setPosition( position );
         currentContent.component.setSize( size );
      }

      // Update the size dummy.
      super.resize( width, height );
   }

   public function addContent( cell :ScaleGridCell, component :IUiComponent ) :Void {
      Debug.assertNotNull( component, "Cannot add null to a ScaleGrid!" );
      if ( Debug.LEVEL > DebugLevel.NONE ) {
         var currentContent :ScaleGridContent;
         var i :Number = m_contents.length;
         while ( currentContent = m_contents[ --i ] ) {
            Debug.assertNotEqual( component, currentContent.component,
               "Attemped to add a component already in the ScaleGrid: " +
               component );
         }
      }

      var content :ScaleGridContent = new ScaleGridContent( cell, component );

      if ( m_onStage ) {
         if ( !component.create( m_container ) ) {
            Debug.LIBRARY_LOG.error( "Failed to add a component to the " +
               "ScaleGrid: Could not create the content component: " +
               component );
            return;
         }
      }

      m_contents.push( content );
   }

   public function removeContent( component :IUiComponent ) :Boolean {
      var found :Boolean = false;

      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         if ( ScaleGridContent( m_contents[ i ] ).component === component ) {
            m_contents.splice( i, 1 );
            if ( m_onStage ) {
               component.destroy();
            }
         }
      }

      return found;
   }

   public function removeAllContents() :Void {
      if ( m_onStage ) {
         for ( var i :Number = 0; i < m_contents.length; ++i ) {
            ScaleGridContent( m_contents[ i ] ).component.destroy();
         }
      }
      m_contents = new Array();
   }

   public function setCellSizes( leftWidth :Number, rightWidth :Number,
      topHeight :Number, bottomHeight :Number ) :Void {

      if ( m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Setting the cell sizes of a ScaleGrid " +
            "that is already on stage has no effect: " + this );
         return;
      }

      m_leftWidth = leftWidth;
      m_rightWidth = rightWidth;
      m_topHeight = topHeight;
      m_bottomHeight = bottomHeight;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "left: " + m_leftWidth,
         "right: " + m_rightWidth,
         "top: " + m_topHeight,
         "bottom: " + m_bottomHeight
      ] );
   }

   private var m_contents :Array;

   // Dimensions of the scale grid rows/columns.
   private var m_leftWidth :Number;
   private var m_rightWidth :Number;
   private var m_topHeight :Number;
   private var m_bottomHeight :Number;
}
