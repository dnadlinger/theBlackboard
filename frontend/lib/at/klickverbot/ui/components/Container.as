import at.klickverbot.ui.layout.stretching.StretchModes;
import at.klickverbot.ui.layout.verticalAlign.VerticalAligns;
import at.klickverbot.ui.layout.horizontalAlign.HorizontalAligns;
import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.ContainerContent;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.horizontalAlign.IHorizontalAlign;
import at.klickverbot.ui.layout.stretching.IStretchMode;
import at.klickverbot.ui.layout.verticalAlign.IVerticalAlign;

class at.klickverbot.ui.components.Container extends CustomSizeableComponent
   implements IUiComponent {

   public function Container() {
      super();
      m_contents = new Array();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      var currentContent :ContainerContent;
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         currentContent = m_contents[ i ];

         if ( !currentContent.component.create( m_container ) ) {
            Debug.LIBRARY_LOG.error( "Could not create the child component: " +
               currentContent.component );
            destroy();
            return false;
         }
      }

      // Now that all already added contents have been put on stage, the initial
      // size of the container is known and the content components can be scaled
      // and positioned according to the policies.
      updateSizeDummy();
      setSize( getSize() );

      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         var currentContent :ContainerContent;
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
         Debug.LIBRARY_LOG.warn( "Attempted to resize a Container that is " +
            "not on stage: " + this );
         return;
      }

      super.resize( width, height );

      var currentContent :ContainerContent;
      var i :Number = m_contents.length;
      while ( currentContent = m_contents[ --i ] ) {
         updateContent( currentContent );
      }
   }

   public function addContent( component :IUiComponent, stretchMode :IStretchMode,
      horizontalAlign :IHorizontalAlign, verticalAlign :IVerticalAlign ) :Void {

      if ( stretchMode == null ) {
         stretchMode = StretchModes.FILL;
      }
      if ( horizontalAlign == null ) {
         horizontalAlign = HorizontalAligns.LEFT;
      }
      if ( verticalAlign == null ) {
         verticalAlign = VerticalAligns.TOP;
      }

      Debug.assertNotNull( component, "Cannot add null to a Container!" );
      Debug.assertExcludes( m_contents, component, "Attemped to add a " +
         "component which is already in the Container: " + component );

      var content :ContainerContent = new ContainerContent(
         component, stretchMode, horizontalAlign, verticalAlign );

      if ( m_onStage ) {
         if ( !component.create( m_container ) ) {
            Debug.LIBRARY_LOG.error( "Failed to add a content component to the " +
               "Container: Could not create the component: " + component );
            return;
         }

         updateContent( content );
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

   private function updateContent( target :ContainerContent ) :Void {
      var size :Point2D = getSize();
      with ( target ) {
         stretchMode.fitToSize( component, size );
         horizontalAlign.move( component, size.x );
         verticalAlign.move( component, size.y );
      }
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(
         "contents.length: " + m_contents.length );
   }

   private var m_contents :Array;
}
