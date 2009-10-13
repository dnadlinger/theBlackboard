import at.klickverbot.ui.components.stretching.StretchModes;
import at.klickverbot.ui.components.ContainerContent;
import at.klickverbot.ui.components.stretching.IStretchMode;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.ui.components.Grid extends CustomSizeableComponent
   implements IUiComponent {

   public function Grid( columnWidth :Number, rowHeight :Number ) {
      super();

      m_contents = new Array();
      m_columnWidth = columnWidth;
      m_rowHeight = rowHeight;
      m_columnSpacing = DEFAULT_COLUMN_SPACING;
      m_rowSpacing = DEFAULT_ROW_SPACING;
      m_layoutSuspended = false;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !createContents() ) {
         // Destroy any already created contents.
         destroy();
         return false;
      }

      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         destroyContents();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Attempted to resize a Grid that is not stage!" );
         return;
      }
      super.resize( width, height );
      createContents();
   }

   public function addContent( component :IUiComponent, stretchMode :IStretchMode ) :Void {
      // Check if the component is not already a member of the Grid, adding a
      // component twice would lead to strange bugs.
      Debug.assertNotNull( component, "Cannot add null to a Grid!" );
      Debug.assertExcludes( m_contents, component,
         "Attemped to add a component which is already in the Grid: {"
         + component + "}" );
      Debug.assertFalse( component.isOnStage(),
         "Cannot add a component to the Grid that is already on stage!" );

      if ( stretchMode == null ) {
         stretchMode = StretchModes.FILL;
      }

      m_contents.push( new ContainerContent( component, stretchMode ) );

      if ( m_onStage ) {
         createContents();
      }
   }

   public function removeContent( component :IUiComponent ) :Boolean {
      var index :Number = null;

      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         if ( ContainerContent( m_contents[ i ] ).component === component ) {
            index = i;
            break;
         }
      }

      if ( index == null ) {
         return false;
      }

      m_contents.splice( index, 1 );
      if ( component.isOnStage() ) {
         component.destroy();
         createContents();
      }

      return true;
   }

   public function removeAllContents() :Void {
      if ( m_onStage ) {
         var currentComponent :IUiComponent;
         for ( var i :Number = 0; i < m_contents.length; ++i ) {
            currentComponent = m_contents[ i ];
            if ( currentComponent.isOnStage() ) {
               currentComponent.destroy();
            }
         }
      }
      m_contents = new Array();
   }

   public function getColumnCount() :Number {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "getColumnCount() called on a Grid which is " +
            "not on stage, will return 0." );
         return 0;
      }

      var size :Point2D = getSize();
      if ( size.x < m_columnWidth ) {
         return 0;
      } else {
         return ( 1 + Math.floor( ( size.x - m_columnWidth ) / ( m_columnWidth + m_columnSpacing ) ) );
      }
   }

   public function getRowCount() :Number {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn( "getRowCount() called on a Grid which is " +
            "not on stage, will return 0." );
         return 0;
      }
      var size :Point2D = getSize();
      if ( size.y < m_rowHeight ) {
         return 0;
      } else {
         return ( 1 + Math.floor( ( size.y - m_rowHeight ) / ( m_rowHeight + m_rowSpacing ) ) );
      }
   }

   public function getCapacity() :Number {
      return ( getColumnCount() * getRowCount() );
   }

   public function getColumnWidth() :Number {
      return m_columnWidth;
   }

   public function setColumnWidth( to :Number ) :Void {
      m_columnWidth = to;
      if ( m_onStage ) {
         createContents();
      }
   }

   public function getRowHeight() :Number {
      return m_rowHeight;
   }

   public function setRowHeight( to :Number ) :Void {
      m_rowHeight = to;
      if ( m_onStage ) {
         createContents();
      }
   }

   public function getColumnSpacing() :Number {
      return m_columnSpacing;
   }

   public function setColumnSpacing( to :Number ) :Void {
      m_columnSpacing = to;
      if ( m_onStage ) {
         createContents();
      }
   }

   public function getRowSpacing() :Number {
      return m_rowSpacing;
   }

   public function setRowSpacing( to :Number ) :Void {
      m_rowSpacing = to;
      if ( m_onStage ) {
         createContents();
      }
   }

   public function suspendLayout() :Void {
      if ( m_layoutSuspended ) {
         Debug.LIBRARY_LOG.warn(	"Grid layout was already suspended, " +
            "forgot to resume it? " + this );
         return;
      }

      m_layoutSuspended = true;
   }

   public function resumeLayout() :Void {
      if ( !m_layoutSuspended ) {
         Debug.LIBRARY_LOG.warn(	"Grid layout was not suspended, " +
            "forgot to suspend it? " + this );
         return;
      }

      m_layoutSuspended = false;
      if ( m_onStage ) {
         createContents();
      }
   }

   private function createContents() :Boolean {
      if ( m_layoutSuspended ) {
         return true;
      }

      var createTime :Number = 0;

      var success :Boolean = true;

      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         var currentContent :ContainerContent = m_contents[ i ];

         if ( i < getCapacity() ) {
            if ( !currentContent.component.isOnStage() ) {
               var createStart :Number = getTimer();
               if ( !currentContent.component.create( m_container ) ) {
                  success = false;

                  // Still try to create the other components – we could be in
                  // a method that can't simply return false – so don't break.
                  continue;
               }
               createTime += getTimer() - createStart;
            }

            currentContent.component.setPosition( getCellPosition( i ) );
            currentContent.stretchMode.fitToSize( currentContent.component,
               new Point2D( m_columnWidth, m_rowHeight ) );
         } else {
            if ( currentContent.component.isOnStage() ) {
               currentContent.component.destroy();
            }
         }
      }

      return success;
   }

   private function getCellPosition( cellIndex :Number ) :Point2D {
      var xIndex :Number = cellIndex % getColumnCount();
      var yIndex :Number = Math.floor( cellIndex / getColumnCount() );

      var xPosition :Number = xIndex * ( m_columnWidth + m_columnSpacing );
      var yPosition :Number = yIndex * ( m_rowHeight + m_rowSpacing );

      return new Point2D( xPosition, yPosition );
   }

   private function destroyContents() :Void {
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         var currentComponent :IUiComponent =
            ContainerContent( m_contents[ i ] ).component;

         if ( currentComponent.isOnStage() ) {
            currentComponent.destroy();
         }
      }
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(
         "contents.length: " + m_contents.length );
   }

   private static var DEFAULT_COLUMN_WIDTH :Number = 100;
   private static var DEFAULT_ROW_HEIGHT :Number = 100;
   private static var DEFAULT_COLUMN_SPACING :Number = 10;
   private static var DEFAULT_ROW_SPACING :Number = 10;

   private var m_contents :Array;

   private var m_columnWidth :Number;
   private var m_rowHeight :Number;

   private var m_columnSpacing :Number;
   private var m_rowSpacing :Number;

   private var m_layoutSuspended :Boolean;
}
