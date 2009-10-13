import at.klickverbot.core.CoreObject;
import at.klickverbot.theme.LayoutRules;
import at.klickverbot.theme.SizeConstraints;
import at.klickverbot.ui.layout.ContainerRule;
import at.klickverbot.ui.layout.ScaleGridCell;
import at.klickverbot.ui.layout.ScaleGridMapping;
import at.klickverbot.ui.layout.ScaleGridType;

class at.klickverbot.theme.ThemeConfig extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ThemeConfig() {
   }

   public static function fromObject( sourceObject :Object ) :ThemeConfig {
      var newInstance :ThemeConfig = new ThemeConfig();
      if ( newInstance.parseObject( sourceObject ) ) {
         return newInstance;
      } else {
         return null;
      }
   }

   public function getThemeName() :String {
      return m_themeName;
   }

   public function getApplicationName() :String {
      return m_applicationName;
   }

   public function getApplicationVersion() :String {
      return m_applicationVersion;
   }

   public function getThemeSwfUrl() :String {
      return m_themeSwfUrl;
   }

   public function getClipFactoryType() :String {
      return m_clipFactoryType;
   }

   public function getLayoutRules() :LayoutRules {
      return m_layoutRules;
   }

   public function getStageSizeConstraints() :SizeConstraints {
      return m_stageSizeConstraints;
   }

   private function parseObject( object :Object ) :Boolean {
      // TODO: Log error messages?

      m_themeName = object[ "name" ];
      if ( m_themeName == null ) {
         return false;
      }

      m_applicationName = object[ "applicationName" ];
      if ( m_applicationName == null ) {
         return false;
      }

      m_applicationVersion = object[ "applicationVersion" ];
      if ( m_applicationVersion == null ) {
         return false;
      }

      m_themeSwfUrl = object[ "themeSwfUrl" ];
      if ( m_themeSwfUrl == null ) {
         return false;
      }

      m_clipFactoryType = object[ "clipFactoryType" ];
      if ( m_clipFactoryType == null ) {
         return false;
      }

      var rawLayoutRules :Object = object[ "layoutRules" ];
      if ( rawLayoutRules != null ) {
         m_layoutRules = parseLayoutRules( rawLayoutRules );
         if ( m_layoutRules == null ) {
            return false;
         }
      } else {
         m_layoutRules = new LayoutRules();
      }

      var rawStageSizeConstraints :Object = object[ "stageSizeConstraints" ];
      if ( rawStageSizeConstraints != null ) {
         var minWidth :Number = Number( rawStageSizeConstraints[ "minWidth" ] );
         if ( ( rawStageSizeConstraints[ "minWidth" ] != null ) && isNaN( minWidth ) ) {
            return false;
         }

         var minHeight :Number = Number( rawStageSizeConstraints[ "minHeight" ] );
         if ( ( rawStageSizeConstraints[ "minHeight" ] != null ) && isNaN( minHeight ) ) {
            return false;
         }

         var maxWidth :Number = Number( rawStageSizeConstraints[ "maxWidth" ] );
         if ( ( rawStageSizeConstraints[ "maxWidth" ] != null ) && isNaN( maxWidth ) ) {
            return false;
         }

         var maxHeight :Number = Number( rawStageSizeConstraints[ "maxHeight" ] );
         if ( ( rawStageSizeConstraints[ "maxHeight" ] != null ) && isNaN( maxHeight ) ) {
            return false;
         }

         m_stageSizeConstraints = new SizeConstraints(
            minWidth, minHeight, maxWidth, maxHeight );
      } else {
         m_stageSizeConstraints = new SizeConstraints( null, null, null, null );
      }

      return true;
   }

   private function parseLayoutRules( rawLayoutRules :Object ) :LayoutRules {
      var layoutRules :LayoutRules = new LayoutRules();

      var rawContainerRules :Object = rawLayoutRules[ "containerRule" ];
      if ( rawContainerRules != null ) {
         var containerRules :Array;
         if ( rawContainerRules instanceof Array ) {
            containerRules = Array( rawContainerRules );
         } else {
            containerRules = new Array( rawContainerRules );
         }

         for ( var i :Number = 0; i < containerRules.length; ++i ) {
            var currentRawRule :Object = containerRules[ i ];

            var containerRule :ContainerRule = new ContainerRule();

            var containerId :String = currentRawRule[ "containerId" ];
            if ( containerId == null ) {
               return null;
            }
            layoutRules.addContainerRule( containerId, containerRule );

            var rawScaleGrid :Object = currentRawRule[ "scaleGrid" ];
            if ( rawScaleGrid != null ) {
               var scaleGrid :ScaleGridMapping = new ScaleGridMapping();

               var rawScaleGridType :String = rawScaleGrid[ "gridType" ];
               if ( rawScaleGridType == "scaleCenterStatic" ) {
                  scaleGrid.setGridType( ScaleGridType.SCALE_CENTER_STATIC );
               } else {
                  return null;
               }

               for ( var key :String in LOCATION_MAPPING ) {
                  addElementsToScaleGridLocation( rawScaleGrid[ key ],
                     scaleGrid, LOCATION_MAPPING[ key ] );
               }
               // TODO: Warn on non-recognised keys.
               containerRule.setScaleGrid( scaleGrid );
            }
         }
      }

      return layoutRules;
   }

   private function addElementsToScaleGridLocation( rawLocationElements :Object,
      scaleGrid :ScaleGridMapping, location :ScaleGridCell ) :Void {

      var elementNames :Object = rawLocationElements[ "elementName" ];
      if ( elementNames != null ) {
         var locationElements :Array;
         if ( elementNames instanceof Array ) {
            locationElements = Array( elementNames );
         } else {
            locationElements = new Array( elementNames );
         }

         for ( var i :Number = 0; i < locationElements.length; ++i ) {
            scaleGrid.addElement( locationElements[ i ], location );
         }
      }
   }

   private static var LOCATION_MAPPING :Object = {
      topLeft: ScaleGridCell.TOP_LEFT,
      top: ScaleGridCell.TOP,
      topRight: ScaleGridCell.TOP_RIGHT,
      left: ScaleGridCell.LEFT,
      center: ScaleGridCell.CENTER,
      right: ScaleGridCell.RIGHT,
      bottomLeft: ScaleGridCell.BOTTOM_LEFT,
      bottom: ScaleGridCell.BOTTOM,
      bottomRight: ScaleGridCell.BOTTOM_RIGHT
   };

   private var m_themeName :String;
   private var m_applicationName :String;
   private var m_applicationVersion :String;
   private var m_themeSwfUrl :String;
   private var m_clipFactoryType :String;
   private var m_layoutRules :LayoutRules;
   private var m_stageSizeConstraints :SizeConstraints;
}