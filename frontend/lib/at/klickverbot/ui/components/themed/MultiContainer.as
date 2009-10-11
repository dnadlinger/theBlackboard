import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.theme.ClipId;
import at.klickverbot.theme.ThemeManager;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McWrapperComponent;
import at.klickverbot.ui.components.ScaleGridContainer;
import at.klickverbot.ui.components.stretching.IStretchMode;
import at.klickverbot.ui.components.stretching.StretchModes;
import at.klickverbot.ui.components.themed.MultiContainerContent;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.layout.ContainerRule;
import at.klickverbot.ui.layout.ScaleGridCell;
import at.klickverbot.ui.layout.ScaleGridMapping;
import at.klickverbot.ui.layout.ScaleGridType;

class at.klickverbot.ui.components.themed.MultiContainer extends Static
   implements IUiComponent {
   /**
    * Constructor.
    *
    * @param clipId The ClipId of the theme clip that is used as container
    *        template.
    */
   public function MultiContainer( clipId :ClipId ) {
      super( clipId );

      m_scaleGridContainer = new ScaleGridContainer();
      m_contents = new Array();
      m_dummyWrappers = new Object();
      m_otherStaticContents = new Array();
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      if ( !super.create( target, depth ) ) {
         return false;
      }

      updateScaleGrid();

      if ( !m_scaleGridContainer.create( m_container ) ) {
         destroy();
         return false;
      }

      // Set the ScaleGridContainer size dummy to the correct size.
      m_scaleGridContainer.setSize( getSize() );

      for ( var childName :String in m_staticContent ) {
         if ( !( m_staticContent[ childName ] instanceof MovieClip ) ) {
            continue;
         }

         var currentClip :MovieClip = MovieClip( m_staticContent[ childName ] );

         var cell :ScaleGridCell = null;
         if ( m_scaleGridMapping ) {
            cell = m_scaleGridMapping.getLocationForElement( childName );
         }
         if ( cell == null ) {
            m_otherStaticContents.push( currentClip );
         } else {
            var wrapper :McWrapperComponent = new McWrapperComponent( currentClip );
            m_dummyWrappers[ childName ] = wrapper;
            m_scaleGridContainer.addContent( wrapper, StretchModes.FILL, cell );
         }
      }

      // Try to put every content component on stage to collect all error messages.
      var success :Boolean = true;
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         success = success && putContentOnStage( m_contents[ i ] );
      }

      if ( !success ) {
         destroy();
         return false;
      }

      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_scaleGridContainer.destroy();
         m_scaleGridContainer.removeAllContents();

         for ( var i :Number = 0; i < m_contents.length; ++i ) {
            MultiContainerContent( m_contents[ i ] ).component.destroy();
         }

         m_dummyWrappers = new Object();
         m_otherStaticContents = new Array();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to resize a MultiContainer that is not on stage: " + this );
         return;
      }

      // Scale any content that might be in the MovieClip skeleton of the
      // container (-> Static). Apply the transformations individually instead
      // of just scaling m_content to support nine-slice scaling.
      var overallXFactor :Number = width / getSize().x;
      var overallYFactor :Number = height / getSize().y;

      var currentClip :MovieClip;
      for ( var i :Number = 0; i < m_otherStaticContents.length; ++i ) {
         currentClip = m_otherStaticContents[ i ];
         currentClip._xscale *= overallXFactor;
         currentClip._yscale *= overallYFactor;
         currentClip._x *= overallXFactor;
         currentClip._y *= overallYFactor;
      }

      // Scale the internal scale grid container which contains the dummies.
      m_scaleGridContainer.resize( width, height );

      // Update the size and position of all content components.
      for ( var i :Number = 0; i < m_contents.length; ++i ) {
         updateContentPositionAndSize( m_contents[ i ] );
      }
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to scale a MultiContainer that is not on stage: " + this );
         return;
      }

      var size :Point2D = getSize();
      resize( size.x * xScaleFactor, size.y * yScaleFactor );
   }

   public function addContent( elementName :String, component :IUiComponent,
      stretchMode :IStretchMode ) :Void {
      Debug.assertNotNull( component, "Cannot add null to a MultiContainer!" );
      Debug.assertExcludes( m_contents, component,
         "Attemped to add a component which is already in the MultiContainer: " +
         component );

      if ( stretchMode == null ) {
         stretchMode = StretchModes.FILL;
      }

      var content :MultiContainerContent = new MultiContainerContent(
         component, stretchMode, elementName );

      m_contents.push( content );

      if ( m_onStage ) {
         putContentOnStage( content );
      }
   }

   private function updateScaleGrid() :Void {
      // Look if there is a scale grid set for this container.
      var containerRule :ContainerRule =
         ThemeManager.getInstance().getTheme().getLayoutRules().getContainerRule( m_clipId );

      if ( containerRule.hasScaleGrid() ) {
         m_scaleGridMapping = containerRule.getScaleGrid();

         // Get size and position of the center cell by iterating through all
         // contents in the center cell and noting the extreme values.
         var leftWidth :Number;
         var topHeight :Number;
         var rightWidth :Number;
         var bottomHeight :Number;

         // TODO: Remove the type thing if not necessary.
         if ( m_scaleGridMapping.getGridType() == ScaleGridType.SCALE_CENTER_STATIC ) {
            var centerElementFound :Boolean = false;

            // Loop through all child clips to build the scale grid dimensions.
            for ( var childName :String in m_staticContent ) {
               var currentClip :MovieClip = m_staticContent[ childName ];
               var contentLocation :ScaleGridCell =
                  m_scaleGridMapping.getLocationForElement( childName );

               if ( contentLocation == ScaleGridCell.CENTER ) {
                  var left :Number = currentClip._x;
                  var top :Number = currentClip._y;
                  var right :Number = getSize().x - ( left + currentClip._width );
                  var bottom :Number = getSize().y - ( top + currentClip._height );

                  // If we have not already encountered a component in the center
                  // cell, use the size of this component as a starting point.
                  // Otherwise enlarge the center cell if the area of this
                  // component exeeds the previous area.
                  if ( !centerElementFound ) {
                     centerElementFound = true;

                     leftWidth = left;
                     topHeight = right;
                     rightWidth = right;
                     bottomHeight = bottom;
                  } else {
                     leftWidth = Math.min( leftWidth, left );
                     topHeight = Math.min( topHeight, top );
                     rightWidth = Math.min( rightWidth, right );
                     bottomHeight = Math.min( bottomHeight, bottom );
                  }
               }
            }

            if ( !centerElementFound ) {
               Debug.LIBRARY_LOG.warn( "The ScaleGrid for the MultiContainer is " +
                  "of type SCALE_CENTER_STATIC, but has nothing in the center cell." );
               m_scaleGridMapping = null;
               return;
            }

            m_scaleGridContainer.setScaleGrid( leftWidth, rightWidth,
               topHeight, bottomHeight );
         } else {
            Debug.LIBRARY_LOG.error( "Unsupported ScaleGridType for a " +
               "MultiContainer: " + m_scaleGridMapping.getGridType() );
            m_scaleGridMapping = null;
            return;
         }
      }
      else {
         // If there is no scale grid set, fall back to "normal" behavior.
         m_scaleGridMapping = null;
         return;
      }
   }

   private function putContentOnStage( content :MultiContainerContent ) :Boolean {
      if ( !content.component.create( m_container ) ) {
         return false;
      }

      updateContentPositionAndSize( content );
      return true;
   }

   private function updateContentPositionAndSize( content :MultiContainerContent ) :Void {
      var dummy :IUiComponent = findDummy( content.elementName );
      if ( dummy == null ) {
         Debug.LIBRARY_LOG.error( "No content dummy found for container element '" +
            content.elementName + "' in container: " + this );
         return;
      }

      content.component.setPosition( dummy.getPosition() );
      content.stretchMode.fitToSize( content.component, dummy.getSize() );
   }

   private function findDummy( name :String ) :IUiComponent {
      if ( m_dummyWrappers[ name ] != null ) {
         return m_dummyWrappers[ name ];
      }

      var currentClip :MovieClip;
      for ( var i :Number = 0; i < m_otherStaticContents.length; ++i ) {
         currentClip = m_otherStaticContents[ i ];
         if ( currentClip._name == name ) {
            m_dummyWrappers[ name ] = new McWrapperComponent( currentClip );
            return m_dummyWrappers[ name ];
         }
      }
   }

   private var m_contents :Array;
   private var m_dummyWrappers :Object;
   private var m_otherStaticContents :Array;
   private var m_scaleGridContainer :ScaleGridContainer;
   private var m_scaleGridMapping :ScaleGridMapping;
}