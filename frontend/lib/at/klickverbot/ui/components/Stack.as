import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.Animator;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.AnimationComponent;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.ui.components.Stack extends CustomSizeableComponent {
   /**
    * Constructor.
    */
   public function Stack() {
      m_contents = new Array();
      m_runningFadeOuts = new Array();
      m_fadeTemplate = DEFAULT_FADE_ANIMATION;
      m_selectedContent = null;
      m_runningFadeIn = null;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( m_selectedContent != null ) {
         if ( !m_selectedContent.create( m_container ) ) {
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
      if ( !checkOnStage( "resize" ) ) return;

      super.resize( width, height );

      if ( m_selectedContent != null ) {
         m_selectedContent.setSize( getSize() );
      }

      var currentAnimation :AnimationComponent;
      var i :Number = m_runningFadeOuts.length;
      while ( currentAnimation = m_runningFadeOuts[ --i ] ) {
         currentAnimation.component.setSize( getSize() );
      }
   }

   public function addContent( component :IUiComponent ) :Void {
      Debug.assertNotNull( component, "Cannot add null to a Stack!" );
      Debug.assertExcludes( m_contents, component,
         "Attemped to add a component which is already in the Stack: " +
         component );
      Debug.assertFalse( component.isOnStage(),
         "Cannot add a component to the Stack that is already on stage: " +
         component );

      m_contents.push( component );

      // If the component is the first one, select it.
      if ( m_contents.length == 1 ) {
         selectComponent( component );
      }
   }

   public function removeContent( component :IUiComponent ) :Boolean {
      var found :Boolean = false;

      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         var currentContent :IUiComponent = m_contents[ i ];
         if ( currentContent === component ) {
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
                     fadeOutContent( component, true );
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
    * Selects a content component to be displayed.
    * 
    * This class was specifically designed to help managing smooth transitions,
    * but in some cases one occasionally needs an instant change to another
    * componenent. To control this animation behavior, the {@code animate}
    * parameter can be used.
    * 
    * @param component The component to be displayed. It must have been added to
    *        the Stack before with {@link addComponent()}. <code>null</code> will
    *        hide the whole stack.
    * @param animate Whether to animate the transition to the new component.
    *        Defaults to {@code true}.
    */
   public function selectComponent( component :IUiComponent, animate :Boolean ) :Void {
   	if ( animate === undefined ) {
   		animate = true;
   	}

      if ( component != null ) {
         Debug.assertIncludes( m_contents, component,
            "Cannot select a component which has not been added." );
      }

      // Check if we have to change something.
      if ( m_selectedContent == component ) {
         return;
      }

      if ( m_onStage ) {
         // Check if the fade in animation of the old entry is still running;
         // if so, jump to its end.
         if ( m_runningFadeIn != null ) {
            m_runningFadeIn.end();
         }

         // Fade the old component out.
         if ( m_selectedContent != null ) {
            fadeOutContent( m_selectedContent, animate );
         }
      }

      m_selectedContent = component;

      if ( m_onStage ) {
         // Create the new component, hide it, and fade it in.
         if ( component != null ) {
            // Check if the newly selected component is still fading out. If so,
            // just end the fade out animation to be able to recreate it below.
            var currentMapping :AnimationComponent;
            var i :Number = m_runningFadeOuts.length;
            while ( currentMapping = m_runningFadeOuts[ --i ] ) {
               if ( currentMapping.component == component ) {
                  currentMapping.animation.end();
                  break;
               }
            }

            component.create( m_container );
            m_selectedContent.setSize( getSize() );
            if ( animate ) {
               component.fade( 0 );
   
               m_runningFadeIn = m_fadeTemplate.clone();
               m_runningFadeIn.setTween( new AlphaTween( component, 1 ) );
               m_runningFadeIn.addEventListener( Event.COMPLETE,
                  this, handleFadeInComplete );
               Animator.getInstance().run( m_runningFadeIn );
            }
         }
      }
   }

   public function getSelectedComponent() :IUiComponent {
      return m_selectedContent;
   }

   private function destroyAllContents() :Void {
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         var currentComponent :IUiComponent = m_contents[ i ];
         if ( currentComponent.isOnStage() ) {
            currentComponent.destroy();
         }
      }
   }

   private function fadeOutContent( component :IUiComponent, animate :Boolean ) :Void {
      var animation :Animation = m_fadeTemplate.clone();
      m_runningFadeOuts.push( new AnimationComponent( animation, component ) );

      animation.setTween( new AlphaTween( component, 0 ) );
      animation.addEventListener( Event.COMPLETE,
         this, handleFadeOutComplete );
      Animator.getInstance().run( animation );
      
      if ( !animate ) {
      	animation.end();
      }
   }

   private function handleFadeInComplete( event :Event ) :Void {
      m_runningFadeIn = null;
   }

   private function handleFadeOutComplete( event :Event ) :Void {
      // The m_fadingOutContents array is only needed because there is no way to
      // extract the target component of the completed animation's tween from
      // the event here.
      var component :IUiComponent = null;
      var currentMapping :AnimationComponent;
      var i :Number = m_runningFadeOuts.length;
      while ( currentMapping = m_runningFadeOuts[ --i ] ) {
         if ( currentMapping.animation == event.target ) {
            component = currentMapping.component;
            m_runningFadeOuts.splice( i, 1 );
            break;
         }
      }

      Debug.assertNotNull( component, "Stack content for fade out animation " +
         event.target + "not found!" );
      component.destroy();
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(
         "contents.length: " + m_contents.length );
   }

   private static var DEFAULT_FADE_ANIMATION :Animation =
      new Animation( null, 0.7, TimeMappers.CUBIC );

   private var m_contents :Array;
   private var m_selectedContent :IUiComponent;

   // TODO: Use a factory instead of copying a template object.
   private var m_fadeTemplate :Animation;

   private var m_runningFadeIn :Animation;
   private var m_runningFadeOuts :Array;
}
