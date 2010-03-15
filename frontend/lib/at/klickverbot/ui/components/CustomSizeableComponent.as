import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.graphics.Color;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;

class at.klickverbot.ui.components.CustomSizeableComponent extends McComponent
   implements IUiComponent {
   public function CustomSizeableComponent() {
      super();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      m_sizeDummy = m_container.createEmptyMovieClip( "sizeDummy",
         m_container.getNextHighestDepth() );

      drawDummyRectangle( m_sizeDummy );

      updateSizeDummy();
      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_sizeDummy.removeMovieClip();
         m_sizeDummy = null;
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      m_sizeDummy._width = width;
      m_sizeDummy._height = height;
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !checkOnStage( "scale" ) ) return;
      var size :Point2D = getSize();
      resize( size.x * xScaleFactor, size.y * yScaleFactor );
   }

   public function getSize() :Point2D {
      return new Point2D( m_sizeDummy._width, m_sizeDummy._height );
   }

   /**
    * Subclasses have to call this after modifying the size outside of
    * <code>resize()</code> or <code>scale()</code> (e.g. after initializing).
    */
   private function updateSizeDummy() :Void {
      m_sizeDummy._width = m_container._width;
      m_sizeDummy._height = m_container._height;
   }

   private function drawDummyRectangle( target :MovieClip ) :Void {
      target.lineStyle( 0, 0, 0 );

      if( Debug.LEVEL >= DebugLevel.HIGH ) {
         target.beginFill( ( new Color(
            Math.random(), Math.random(), Math.random() ) ).toHex(), 30 );
      } else {
         target.beginFill( 0, 0 );
      }

      target.moveTo( 0, 0 );
      target.lineTo( 1, 0 );
      target.lineTo( 1, 1 );
      target.lineTo( 0, 1 );
      target.lineTo( 0, 0 );

      target.endFill();
   }

   private var m_sizeDummy :MovieClip;
}
