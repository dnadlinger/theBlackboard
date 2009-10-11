import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.util.ColorUtils;

class at.klickverbot.ui.components.CustomSizeableComponent extends McComponent
   implements IUiComponent {
   public function CustomSizeableComponent() {
      super();
   }

   public function create( target :MovieClip, depth :Number ) :Boolean {
      if ( !super.create( target, depth ) ) {
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
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attemped to resize a component that is not on stage: " + this );
         return;
      }
      m_sizeDummy._width = width;
      m_sizeDummy._height = height;
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.warn(
            "Attemped to scale a component that is not on stage: " + this );
         return;
      }
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

      if( Debug.LEVEL >= Debug.LEVEL_HIGH ) {
         target.beginFill( ColorUtils.rgbToHex(
            Math.random(), Math.random(), Math.random() ), 30 );
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
