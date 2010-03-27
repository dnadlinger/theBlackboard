import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.components.themed.Static;

/**
 * A simple themed label displaying HTML text, optionally with a background.
 *
 * It is resized according to the contents, but will never be larger than the
 * size specified via resize/scale/setSize (if any).
 */
class at.klickverbot.ui.components.themed.Label extends Static {
   public function Label( clipId :ClipId, text :String ) {
      super( clipId );
      m_text = text;

      m_maxWidth = null;
      m_maxHeight = null;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      m_textFieldClip = getChildClip( TEXT_FIELD_CLIP_NAME, true );
      if ( m_textFieldClip == null ) {
         super.destroy();
         return false;
      }

      m_textField = m_textFieldClip[ TEXT_FIELD_NAME ];
       if ( m_textField == null ) {
         Debug.LIBRARY_LOG.error( "Attempted to create a Label using a " +
            "clip that does not have a TextField in its text field clip: " + this );
         super.destroy();
         return false;
      }

      m_background = getChildClip( BACKGROUND_NAME );
      if ( m_background ) {
         m_leftDistance = m_textField._x;
         m_topDistance = m_textField._y;
         m_rightDistance = m_background._width -
            ( m_textField._x + m_textField._width );
         m_bottomDistance = m_background._height -
            ( m_textField._y + m_textField._height );
      }

      m_textField.autoSize = true;
      m_textField.htmlText = m_text;
      updateSize();

      return true;
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;

      m_maxWidth = width;
      m_maxHeight = height;
      updateSize();
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !checkOnStage( "scale" ) ) return;

      var size :Point2D = getSize();
      resize( size.x * xScaleFactor, size.y * yScaleFactor );
   }

   public function get text() :String {
      return m_text;
   }
   public function set text( to :String ) :Void {
      m_text = to;
      if ( m_onStage ) {
         m_textField.htmlText = text;
         updateSize();
      }
   }

   private function updateSize() :Void {
      var additionalWidth :Number = 0;
      if ( m_background != null ) {
         additionalWidth = m_leftDistance + m_rightDistance;
      }

      var additionalHeight :Number = 0;
      if ( m_background != null ) {
         additionalHeight = m_topDistance + m_bottomDistance;
      }

      if ( m_maxWidth != null ) {
         m_textField._width = Math.min( m_maxWidth,
            ( m_textField._width + additionalWidth ) ) - additionalWidth;
      }

      if ( m_maxHeight != null ) {
         m_textField._height = Math.min( m_maxHeight,
            ( m_textField._height + additionalHeight ) ) - additionalHeight;
      }

      if ( m_background != null ) {
         m_background._width = m_textField._width + additionalWidth;
         m_background._height = m_textField._height + additionalHeight;
      }

      // TODO: What about other, unnamed clip contents?
      // If they are not scaled, they could break e.g. containers which rely on
      // proper resizing behavior. Maybe adapt/refactor the code from
      // MultiContainer?
   }


   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "text: \"" + m_text + "\"" );
   }

   private static var TEXT_FIELD_CLIP_NAME :String = "textFieldClip";
   private static var TEXT_FIELD_NAME :String = "textField";
   private static var BACKGROUND_NAME :String = "background";

   private var m_text :String;

   private var m_textFieldClip :MovieClip;
   private var m_textField :TextField;
   private var m_background :MovieClip;

   private var m_maxWidth :Number;
   private var m_maxHeight :Number;

   private var m_leftDistance :Number;
   private var m_topDistance :Number;
   private var m_rightDistance :Number;
   private var m_bottomDistance :Number;
}
