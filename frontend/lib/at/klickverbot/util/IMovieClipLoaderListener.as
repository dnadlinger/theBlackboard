interface at.klickverbot.util.IMovieClipLoaderListener {
   public function onLoadComplete( targetMc :MovieClip,
      httpStatus :Number ) :Void;
   public function onLoadError( targetMc :MovieClip,
      errorCode :String, httpStatus :Number ) :Void;
   public function onLoadInit( targetMc :MovieClip ) :Void;
   public function onLoadProgress( targetMc :MovieClip,
      loadedBytes :Number, totalBytes :Number ) :Void;
   public function onLoadStart( targetMc :MovieClip ) :Void;
}
