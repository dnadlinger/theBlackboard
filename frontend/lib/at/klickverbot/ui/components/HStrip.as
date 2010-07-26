import at.klickverbot.debug.Debug;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.ui.components.HStrip extends CustomSizeableComponent
   implements IUiComponent {

   public function HStrip() {
      super();

      m_widthLimit = 0;
      m_hSpacing = DEFAULT_H_SPACING;
      m_vSpacing = DEFAULT_W_SPACING;

      m_contentComponents = new Array();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !createContents() ) {
         // Destroy any already created components.
         destroy();
         return false;
      }

      updateSizeDummy();
      return true;
   }

   /**
    * Destroys the visible part of the component.
    * It can be recreated using @link{ #create }.
    */
   public function destroy() :Void {
      if ( m_onStage ) {
         destroyContents();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      // Do not react to height changes, but set the width limit according to the
      // parameter and rearrange the contents.
      m_widthLimit = width;
      createContents();
   }

   public function addContent( component :IUiComponent ) :Boolean {
      Debug.assertNotNull( component, "Cannot add a null component!" );
      Debug.assertExcludes( m_contentComponents, component,
         "Attempted to add a component that is already in the strip: " +
         component + "!" );

      if ( component.isOnStage() ) {
         Debug.LIBRARY_LOG.warn( "Attempted to add a component that is already " +
            "on stage (" + component + ") to " + this + "!" );
         return false;
      }

      m_contentComponents.push( component );

      if ( m_onStage ) {
         createContents();
      }

      return true;
   }

   public function getHSpacing() :Number {
      return m_hSpacing;
   }
   public function setHSpacing( to :Number ) :Void {
      Debug.assertNumber( to, "Attempted to set illegal hSpacing!" );
      m_hSpacing = to;
      createContents();
   }

   public function getVSpacing() :Number {
      return m_vSpacing;
   }
   public function setVSpacing( to :Number ) :Void {
      Debug.assertNumber( to, "Attempted to set illegal vSpacing!" );
      m_vSpacing = to;
      createContents();
   }

   private function createContents() :Boolean {
      var success :Boolean = true;

      var currentRowWidth :Number = 0;

      var maxHeight :Number = 0;
      var rowOffset :Number = m_vSpacing;

      for ( var i :Number = 0; i < m_contentComponents.length; ++i ) {
         var currentComponent :IUiComponent = m_contentComponents[ i ];

         if ( !currentComponent.isOnStage() ) {
            if ( !currentComponent.create( m_container ) ) {
               success = false;
               // Still try to create the other components in order to get a
               // complete error list, so don't break.
               continue;
            }
         }

         var componentWidth :Number = currentComponent.getSize().x;
         var componentHeight :Number = currentComponent.getSize().y;

         var compnentX :Number = currentRowWidth + m_hSpacing;

         if ( ( m_widthLimit > 0 ) && ( ( compnentX + componentWidth ) > m_widthLimit ) ) {
            currentRowWidth = 0;
            compnentX = m_hSpacing;
            rowOffset += ( maxHeight + m_vSpacing );
            maxHeight = 0;
         }

         currentComponent.move( compnentX, rowOffset );

         currentRowWidth += ( m_hSpacing + componentWidth );
         maxHeight = Math.max( maxHeight, componentHeight );
      }

      return success;
   }

   private function destroyContents() :Void {
      for ( var i :Number = 0; i < m_contentComponents.length; ++i ) {
         if ( m_contentComponents[ i ].isOnStage() ) {
            m_contentComponents[ i ].destroy();
         }
      }
   }

   private static var DEFAULT_H_SPACING :Number = 5;
   private static var DEFAULT_W_SPACING :Number = 5;

   private var m_widthLimit :Number;
   private var m_hSpacing :Number;
   private var m_vSpacing :Number;

   private var m_contentComponents :Array;
}
