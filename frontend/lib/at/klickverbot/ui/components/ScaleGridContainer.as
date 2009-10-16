import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.ContainerContent;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.HorizontalAlign;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.ScaleGridContainerContent;
import at.klickverbot.ui.components.VerticalAlign;
import at.klickverbot.ui.components.stretching.IStretchMode;
import at.klickverbot.ui.layout.ScaleGridCell;

class at.klickverbot.ui.components.ScaleGridContainer extends CustomSizeableComponent
   implements IUiComponent {

   /**
    * Constructor.
    */
   public function ScaleGridContainer() {
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

      var currentContent :ScaleGridContainerContent;
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         currentContent = m_contents[ i ];

         if ( !currentContent.component.create( m_container ) ) {
            Debug.LIBRARY_LOG.error( "Could not create the component " +
               currentContent.component + " for the container element " +
                  currentContent.cell );
            destroy();
            return false;
         }
         // TODO: Why was this commented out?
//			placeAndResizeContent( currentContent );
      }

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         var currentContent :ScaleGridContainerContent;
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
         Debug.LIBRARY_LOG.warn( "Attempted to resize a ScaleGridContainer " +
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
         Debug.LIBRARY_LOG.warn( "Could not fully resize the ScaleGridContainer " +
            "because it would be smaller than the limits resulting from the scale " +
            "grid (" + outerWidth + "x" + outerHeight + ")." );
         return;
      }

      // Resize and/or move each content component according to its position
      // in the scale grid. We have to treat all components in one cell as if
      // the cell was a single unit, so we also have to move them accordingly
      // to reflect the process in an imaginary single cell.
      var currentContent :ScaleGridContainerContent;
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         currentContent = m_contents[ i ];

         var position :Point2D = currentContent.component.getPosition();
         var size :Point2D = currentContent.component.getSize();

         // If the component is in the middle column, it is scaled along
         // the x axis.
         // If the component is in the right column, it is moved along the x
         // axis.
         if ( currentContent.cell.column == HorizontalAlign.CENTER ) {
            if ( oldCenterWidth > 0 ) {
               var xScaleFactor :Number = newCenterWidth / oldCenterWidth;
               size.x *= xScaleFactor;
               position.x += ( xScaleFactor - 1 )  * ( position.x - m_leftWidth );
            } else {
               size.x = newCenterWidth;
               position.x = m_leftWidth;
            }
         } else if ( currentContent.cell.row == HorizontalAlign.RIGHT ) {
            position.x += width - oldSize.x;
         }

         // If the component is in the middle *row*, it is scaled along the
         // y axis.
         // If the component is in the bottom row, it is moved along the y
         // axis.
         if ( currentContent.cell.row == VerticalAlign.CENTER ) {
            if ( oldCenterHeight > 0 ) {
               var yScaleFactor :Number = newCenterHeight / oldCenterHeight;
               size.y *= yScaleFactor;
               position.y += ( yScaleFactor - 1 )  * ( position.y - m_topHeight );
            } else {
               size.y = newCenterHeight;
               position.y = m_topHeight;
            }
         } else if ( currentContent.cell.row == VerticalAlign.BOTTOM ) {
            position.y += height - oldSize.y;
         }

         currentContent.component.setPosition( position );
         currentContent.stretchMode.fitToSize( currentContent.component, size );
      }

      // Update the size dummy.
      super.resize( width, height );
   }

   public function addContent( component :IUiComponent, stretchMode :IStretchMode,
      cell :ScaleGridCell ) :Void {

      Debug.assertNotNull( component, "Cannot add null to a ScaleGridContainer!" );
      Debug.assertExcludes( m_contents, component, "Attemped to add a " +
         "component which is already in the ScaleGridContainer: " + component );

      var content :ScaleGridContainerContent =
         new ScaleGridContainerContent( component, stretchMode, cell );

      if ( m_onStage ) {
         if ( !component.create( m_container ) ) {
            Debug.LIBRARY_LOG.error( "Failed to add a component to the " +
               "ScaleGridContainer: Could not create the content component: " +
               component );
            return;
         }
//			placeAndResizeContent( content );
      }

      m_contents.push( content );
   }

   public function removeContent( component :IUiComponent ) :Boolean {
      var found :Boolean = false;

      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         if ( ContainerContent( m_contents[ i ] ).component === component ) {
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
            ContainerContent( m_contents[ i ] ).component.destroy();
         }
      }
      m_contents = new Array();
   }

   public function setScaleGrid( leftWidth :Number, rightWidth :Number,
      topHeight :Number, bottomHeight :Number ) :Void {

      if ( m_onStage ) {
         Debug.LIBRARY_LOG.warn( "Setting the scale grid of a ScaleGridContainer " +
            "that is already on stage has no effect!" );
         return;
      }

      m_leftWidth = leftWidth;
      m_rightWidth = rightWidth;
      m_topHeight = topHeight;
      m_bottomHeight = bottomHeight;
   }

//	private function placeAndResizeContent( content :ScaleGridContainerContent ) :Void {
//		var position :Point2D = content.component.getPosition();
//		var size :Point2D = content.component.getSize();
//
//		if ( content.cell.column == HorizontalAlign.LEFT ) {
//			position.x = 0;
//			size.x = m_leftWidth;
//		} else if ( content.cell.column == HorizontalAlign.CENTER ) {
//			position.x = m_leftWidth;
//			size.x = getSize().x - m_leftWidth - m_rightWidth;
//		} else if ( content.cell.column == HorizontalAlign.RIGHT ) {
//			position.x = getSize().x - m_rightWidth;
//			size.x = m_rightWidth;
//		}
//
//		if ( content.cell.row == VerticalAlign.TOP ) {
//			position.y = 0;
//			size.y = m_topHeight;
//		} else if ( content.cell.row == VerticalAlign.CENTER ) {
//			position.y = m_topHeight;
//			size.y = getSize().y - m_topHeight - m_bottomHeight;
//		} else if ( content.cell.row == VerticalAlign.BOTTOM ) {
//			position.y = getSize().y - m_bottomHeight;
//			size.y = m_bottomHeight;
//		}
//
//		fitContentToSize( content, size );
//	}

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
