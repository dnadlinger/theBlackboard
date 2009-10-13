import at.klickverbot.debug.Debug;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;

/**
 * A component that simply wraps a MovieClip and allows for other components
 * to be added as children.
 *
 * Intentionally provides <em>no</em> extra functionality such as respecting
 * the resize functions of its childrens, etc.
 *
 */
class at.klickverbot.ui.components.GenericContainer extends McComponent
   implements IUiComponent {

   /**
    * Constructor.
    */
   public function GenericContainer() {
      m_components = new Array();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      for ( var i :Number = 0; i < m_components.length; ++i ) {
         if ( !IUiComponent( m_components[ i ] ).create( m_container ) ) {
            destroy();
            return false;
         }
      }

      return true;
   }

   public function destroy() :Void {
      var currentComponent :IUiComponent;
      var i :Number = m_components.length;

      while ( currentComponent = m_components[ --i ] ) {
   	   // Check if the components are on stage before destorying them. Not
         // doing so could result destroy() being called two times if the UI
         // is destroyed because a child of this container could not be
         // created.
         if ( currentComponent.isOnStage() ) {
            currentComponent.destroy();
         }
      }
      super.destroy();
   }

   public function addContent( component :IUiComponent ) :Void {
      Debug.assertNotNull( component, "Cannot add null to a GenericContainer!" );
      Debug.assertExcludes( m_components, component,
         "Attemped to add a component which is already in the GenericContainer: {"
         + component + "}" );
      Debug.assertFalse( component.isOnStage(),
         "Cannot add a component to the GenericContainer that is already on stage!" );

      m_components.push( component );

      if ( m_onStage ) {
         component.create( m_container );
      }
   }

   public function removeContent( component :IUiComponent ) :Boolean {
      var found :Boolean = false;

      for ( var i :Number = 0; i < m_components.length; ++i ) {
         if ( m_components[ i ] === component ) {
            m_components.splice( i, 1 );
            if ( m_onStage ) {
               component.destroy();
            }
         }
      }

      return found;
   }

   public function removeAllContents() :Void {
      if ( m_onStage ) {
         for ( var i :Number = 0; i < m_components.length; ++i ) {
            IUiComponent( m_components[ i ] ).destroy();
         }
      }
      m_components = new Array();
   }

   private var m_components :Array;
}
