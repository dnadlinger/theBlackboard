import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.ContainerContent;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.stretching.IStretchMode;
import at.klickverbot.ui.components.stretching.StretchModes;

class at.klickverbot.ui.components.Stack extends CustomSizeableComponent
   implements IUiComponent {

   /**
    * Constructor.
    */
   public function Stack() {
      m_contents = new Array();
      m_fadeTemplate = DEFAULT_FADE_ANIMATION;
      m_runningFadeIn = null;
      m_runningFadeOut = null;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( m_selectedContent != null ) {
         if ( !m_selectedContent.component.create( m_container ) ) {
            destroy();
            return false;
         }
      }
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         destroyAllContents();
      }

      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to resize a component that is not on stage: " + this );
         return;
      }

      super.resize( width, height );

      if ( m_selectedContent != null ) {
         m_selectedContent.stretchMode.fitToSize( m_selectedContent.component, getSize() );
      }

      if ( m_runningFadeOut != null ) {
         m_oldSelectedContent.stretchMode.fitToSize( m_oldSelectedContent.component, getSize() );
      }
   }

   public function addContent( component :IUiComponent, stretchMode :IStretchMode ) :Void {
      Debug.assertNotNull( component, "Cannot add null to a Stack!" );
      Debug.assertExcludes( m_contents, component,
         "Attemped to add a component which is already in the Stack: {" +
         component + "}" );
      Debug.assertFalse( component.isOnStage(),
         "Cannot add a component to the Stack that is already on stage!" );

      if ( stretchMode == null ) {
         stretchMode = StretchModes.FILL;
      }

      var newContent :ContainerContent = new ContainerContent( component, stretchMode );
      m_contents.push( newContent );

      // If the component is the first one, select it.
      if ( m_contents.length == 1 ) {
         m_selectedContent = newContent;
         if ( m_onStage ) {
            component.create( m_container );
            m_selectedContent.stretchMode.fitToSize( m_selectedContent.component, getSize() );
         }
      }
   }

   public function removeContent( component :IUiComponent ) :Boolean {
      var found :Boolean = false;

      var currentContent :ContainerContent;
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         currentContent = m_contents[ i ];
         if ( currentContent.component === component ) {
            m_contents.splice( i, 1 );

            if ( m_selectedContent == component ) {
               // If there are any content components left, display the next one
               // in the list.
               if ( m_contents.length > 0 ) {
                  var selectedIndex :Number = i;
                  if ( selectedIndex > ( m_contents.length - 1 ) ) {
                     selectedIndex = m_contents.length - 1;
                  }
                  selectComponent( m_contents[ selectedIndex ] );
               } else {
                  // We can't select any other component, so fade it out manually.
                  if ( m_onStage ) {
                     m_oldSelectedContent = currentContent;
                     m_runningFadeOut = m_fadeTemplate.clone();
                     m_runningFadeOut.setTween( new AlphaTween( component, 0 ) );
                     m_runningFadeOut.addEventListener( Event.COMPLETE,
                        this, handleFadeOutComplete );
                     Animator.getInstance().add( m_runningFadeOut );
                  }
                  m_selectedContent = null;
               }
            }
         }
      }

      return found;
   }

   public function removeAllContents() :Void {
      if ( m_onStage ) {
         destroyAllContents();
      }
      m_contents = new Array();
   }

   /**
    * Selects the component to be displayed.
    * <code>null</code> will hide the whole stack.
    */
   public function selectComponent( component :IUiComponent ) :Void {
      var content :ContainerContent = findContentForComponent( component );

      if ( component != null ) {
         // TODO: Using assert this way is not quite clean.
         Debug.assertNotNull( content,
            "Cannot select a component which has not been added." );
      }

      // Check if we have to change something.
      if ( m_selectedContent == content ) {
         return;
      }

      m_oldSelectedContent = m_selectedContent;
      m_selectedContent = content;

      if ( m_onStage ) {
         // Check if there is some old animations running; if so, jump to their end.
         if ( m_runningFadeIn != null ) {
            m_runningFadeIn.end();
         }
         if ( m_runningFadeOut != null ) {
            m_runningFadeOut.end();
         }

         // Fade the old component out.
         if ( m_oldSelectedContent != null ) {
            m_runningFadeOut = m_fadeTemplate.clone();
            m_runningFadeOut.setTween( new AlphaTween( m_oldSelectedContent.component, 0 ) );
            m_runningFadeOut.addEventListener( Event.COMPLETE, this, handleFadeOutComplete );
            Animator.getInstance().add( m_runningFadeOut );
         }

         // Create the new component, hide it, and fade it in.
         if ( component != null ) {
            component.create( m_container );
            m_selectedContent.stretchMode.fitToSize( component, getSize() );
            component.fade( 0 );

            m_runningFadeIn = m_fadeTemplate.clone();
            m_runningFadeIn.setTween( new AlphaTween( component, 1 ) );
            m_runningFadeIn.addEventListener( Event.COMPLETE, this, handleFadeInComplete );
            Animator.getInstance().add( m_runningFadeIn );
         }
      }
   }

   public function getSelectedComponent() :IUiComponent {
      return m_selectedContent.component;
   }

   private function destroyAllContents() :Void {
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         var currentComponent :IUiComponent = ContainerContent( m_contents[ i ] ).component;
         if ( currentComponent.isOnStage() ) {
            currentComponent.destroy();
         }
      }
   }

   private function handleFadeInComplete( event :Event ) :Void {
      m_runningFadeIn = null;
   }

   private function handleFadeOutComplete( event :Event ) :Void {
      m_oldSelectedContent.component.destroy();
      m_runningFadeOut = null;
   }

   private function findContentForComponent( component :IUiComponent ) :ContainerContent {
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         if ( ContainerContent( m_contents[ i ] ).component === component ) {
            return m_contents[ i ];
         }
      }
      return null;
   }

   private static var DEFAULT_FADE_ANIMATION :Animation =
      new Animation( null, 0.7, TimeMappers.CUBIC );

   private var m_contents :Array;
   private var m_selectedContent :ContainerContent;
   private var m_oldSelectedContent :ContainerContent;

   private var m_fadeTemplate :Animation;
   private var m_runningFadeIn :Animation;
   private var m_runningFadeOut :Animation;
}
