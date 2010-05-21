import at.klickverbot.graphics.Point2D;
import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.components.CustomSizeableComponent;
import at.klickverbot.util.Delegate;
import at.klickverbot.util.IMovieClipLoaderListener;

class at.klickverbot.ui.components.RemoteImage extends CustomSizeableComponent {
   public function RemoteImage( url :String ) {
      m_url = url;
   }

   private function createUi() :Boolean {
      if ( !super.createUi() ) {
         return false;
      }

      m_imageContainerClip = m_container.createEmptyMovieClip( "imageContainer",
         m_container.getNextHighestDepth() );

      m_targetClip = m_imageContainerClip.createEmptyMovieClip( "imageTarget",
         m_imageContainerClip.getNextHighestDepth() );

      var loader :MovieClipLoader = new MovieClipLoader();

      var listener :IMovieClipLoaderListener = new IMovieClipLoaderListener();
      listener.onLoadInit = Delegate.create( this, handleLoadComplete );
      listener.onLoadError = Delegate.create( this, handleLoadError );
      loader.addListener( listener );

      loader.loadClip( m_url, m_targetClip );

      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_targetClip.removeMovieClip();
         m_imageContainerClip.removeMovieClip();
      }
      super.destroy();
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;
      super.resize( width, height );

      resizeImage();
   }

   private function resizeImage() :Void {
      var size :Point2D = getSize();
      m_imageContainerClip._width = size.x;
      m_imageContainerClip._height = size.y;
   }

   private function handleLoadComplete( targetMc :MovieClip ) :Void {
      resizeImage();
      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   private function handleLoadError( targetMc :MovieClip, errorCode :String,
      httpStatus :Number ) :Void {
      Debug.LIBRARY_LOG.error( "Could not load image (errorCode: " + errorCode +
         ", httpStatus: " + httpStatus + "): " + this );
      dispatchEvent( new Event( Event.EXTERN_FAILED, this ) );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "url: " + m_url );
   }

   private var m_url :String;
   private var m_imageContainerClip :MovieClip;
   private var m_targetClip :MovieClip;
}
