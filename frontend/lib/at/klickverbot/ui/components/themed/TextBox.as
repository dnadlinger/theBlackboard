import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McWrapperComponent;
import at.klickverbot.ui.components.ScaleGridContainer;
import at.klickverbot.ui.components.stretching.StretchModes;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.layout.ScaleGridCell;

class at.klickverbot.ui.components.themed.TextBox extends Static
   implements IUiComponent {

   public function TextBox( clipId :ClipId ) {
      super( clipId );

      m_textFieldContainer = new ScaleGridContainer();
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      if ( !super.create( target, depth ) ) {
         return false;
      }

      m_textFieldClip = m_staticContent[ TEXT_FIELD_CLIP_NAME ];
      if ( m_textFieldClip == null ) {
         Debug.LIBRARY_LOG.error( "Attempted to create a TextBox using a " +
            "clip that does not have a child text field clip: " + this );
         super.destroy();
         return false;
      }

      m_textField = m_textFieldClip[ TEXT_FIELD_NAME ];
      if ( m_textField == null ) {
         Debug.LIBRARY_LOG.error( "Attempted to create a TextBox using a " +
            "clip that does not have a TextField in its text field clip: " + this );
         super.destroy();
         return false;
      }

      m_background = m_staticContent[ BACKGROUND_NAME ];

      m_textFieldContainer.setScaleGrid(
         m_textField._x,
         m_staticContent._width - m_textField._x - m_textField._width,
         m_textField._y,
         m_staticContent._height - m_textField._y - m_textField._height
      );

      m_textFieldContainer.addContent( new McWrapperComponent( m_textFieldClip ),
         StretchModes.FILL, ScaleGridCell.CENTER );

      m_textFieldContainer.create( m_container );

      m_textField.text = "";

      return true;
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to resize a Textbox that is not on stage: " + this );
         return;
      }

      m_textFieldContainer.resize( width, height );

      if ( m_background != null ) {
         m_background._width = width;
         m_background._height = height;
      }
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attempted to scale a Textbox that is not on stage: " + this );
         return;
      }

      var size :Point2D = getSize();
      resize( size.x * xScaleFactor, size.y * yScaleFactor );
   }

   // TODO: Quick'n'dirty, swap out for m_text and m_htmlText properties that can be set before the component is put on stage.
   public function get text() :String {
      return m_textField.text;
   }
   public function set text( to :String ) :Void {
      m_textField.text = to;
   }

   private static var TEXT_FIELD_CLIP_NAME :String = "textFieldClip";
   private static var TEXT_FIELD_NAME :String = "textField";
   private static var BACKGROUND_NAME :String = "background";

   private var m_textFieldClip :MovieClip;
   private var m_textField :TextField;
   private var m_background :MovieClip;
   private var m_textFieldContainer :ScaleGridContainer;
}
