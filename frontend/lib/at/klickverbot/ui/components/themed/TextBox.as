import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McWrapperComponent;
import at.klickverbot.ui.components.ScaleGridContainer;
import at.klickverbot.ui.components.stretching.StretchModes;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.layout.ScaleGridCell;
import at.klickverbot.ui.mouse.MouseoverManager;
import at.klickverbot.ui.mouse.PointerManager;
import at.klickverbot.util.Delegate;

class at.klickverbot.ui.components.themed.TextBox extends Static
   implements IUiComponent {

   public function TextBox( clipId :ClipId ) {
      super( clipId );

      m_textFieldContainer = new ScaleGridContainer();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
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
         m_textFieldClip._x,
         m_staticContent._width - m_textFieldClip._x - m_textFieldClip._width,
         m_textFieldClip._y,
         m_staticContent._height - m_textFieldClip._y - m_textFieldClip._height
      );
      m_textFieldContainer.addContent( new McWrapperComponent( m_textFieldClip ),
         StretchModes.FILL, ScaleGridCell.CENTER );
      m_textFieldContainer.create( m_container );

      // Install handlers to update the background when the textfield
      // gets/looses focus.
      m_textField.onSetFocus = Delegate.create( this, gotFocus );
      m_textField.onKillFocus = Delegate.create( this, lostFocus );

      // Also focus the textfield when the background is pressed.
      if ( m_background != null ) {
      	m_background.onRelease = Delegate.create( this, backgroundClicked );
      }

      // Hide any custom pointer when the mouse is over the textfield because
      // the caret cursor is displayed by the system then (there is no known
      // workaround for this).
      MouseoverManager.getInstance().addArea(
         m_textFieldClip, handleMouseOver, handleMouseOut, true );

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


   private function gotFocus() :Void {
      if ( m_background != null ) {
         m_background.gotoAndPlay( "focus" );
      }
   }

   private function lostFocus() :Void {
      if ( m_background != null ) {
         m_background.gotoAndPlay( "active" );
      }
   }

   private function handleMouseOver() :Void {
      PointerManager.getInstance().suspendCustomPointer();
      Mouse.hide();
   }

   private function handleMouseOut() :Void {
      PointerManager.getInstance().resumeCustomPointer();
   }

   private function backgroundClicked() :Void {
      Selection.setFocus( m_textField );
   }

   private static var TEXT_FIELD_CLIP_NAME :String = "textFieldClip";
   private static var TEXT_FIELD_NAME :String = "textField";
   private static var BACKGROUND_NAME :String = "background";

   private var m_textFieldClip :MovieClip;
   private var m_textField :TextField;
   private var m_background :MovieClip;
   private var m_textFieldContainer :ScaleGridContainer;
}
