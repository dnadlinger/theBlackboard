import flash.geom.ColorTransform;
import flash.geom.Matrix;
import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.mouse.MouseoverArea;
import at.klickverbot.util.Delegate;
import at.klickverbot.util.DummyClipManager;
import at.klickverbot.util.McUtils;

import flash.display.BitmapData;
import flash.geom.Point;

/**
 * This class helps to solve the problem that there are no true, bubbling
 * RollOver-/RollOut events in ActionScript2.
 */
class at.klickverbot.ui.mouse.MouseoverManager extends CoreObject {
   /**
     * Constructor.
     * Private to allow no other instances.
     */
   private function MouseoverManager() {
      m_areas = new Array();
      m_clip = DummyClipManager.getInstance().createClip();
      m_clip.onMouseMove = Delegate.create( this, onMouseMove );
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of RolloverManager.
    */
   public static function getInstance() :MouseoverManager {
      if ( m_instance == null ) {
         m_instance = new MouseoverManager();
      }
      return m_instance;
   }

   public function addArea( activeArea :MovieClip, overHandler :Function,
      outHandler :Function, onlyBoundingBox :Boolean ) :Void {
      if ( onlyBoundingBox == null ) {
         onlyBoundingBox = false;
      }

      Debug.assertNotNull( activeArea,
         "Active mouseover area must not be null." );

      m_areas.push( new MouseoverArea(
         activeArea, overHandler, outHandler, onlyBoundingBox ) );
   }

   public function removeArea( activeArea :MovieClip ) :Boolean {
      // TODO: Refactor all classes which use removeXyz() functions to use common container classes internally?
      var found :Boolean = false;

      var currentArea :MouseoverArea;
      var currentIndex :Number = m_areas.length;
      while ( currentArea = m_areas[ --currentIndex ] ) {
         if ( currentArea.activeArea == activeArea ) {
            m_areas.splice( currentIndex, 1 );
            found = true;
            break;
         }
      }

      return found;
   }

   public function isAreaHovered( activeArea :MovieClip ) :Boolean {
      var area :MouseoverArea = null;

      var currentArea :MouseoverArea;
      var currentIndex :Number = m_areas.length;
      while ( currentArea = m_areas[ --currentIndex ] ) {
         if ( currentArea.activeArea == activeArea ) {
            area = currentArea;
            break;
         }
      }

      Debug.assertNotNull( area, "isAreaHovered() called for a MovieClip not " +
         "registered as mouseover area: " + activeArea );

      return area.currentlyOver;
   }

   private function onMouseMove() :Void {
      var globalPosition :Point2D = McUtils.localToGlobal( m_clip,
         new Point2D( m_clip._xmouse, m_clip._ymouse ) );

      var currentArea :MouseoverArea;
      var currentIndex :Number = m_areas.length;

      while ( currentArea = m_areas[ --currentIndex ] ) {
         var active :MovieClip = currentArea.activeArea;

         if ( !active._visible ) {
            // This is intended to keep compabtibility with onRollOver/onRollOut,
            // because MovieClips with _visible = false do not recieve any mouse
            // events there.
            continue;
         }

         var over :Boolean =
            active.hitTest( globalPosition.x, globalPosition.y, false );
         if ( over && !currentArea.boundingBoxOnly ) {
            // If the pointer is inside the bounding box, render the active area
            // to a bitmap and perform the hit test on the pixel data. Because
            // any children MovieClips with _visible = false the active area
            // might have are not drawn this way, we get the desired result.

            // We have to use getBounds() here to get the size of the MovieClip
            // in its own coordinate system since bitmap.draw() works in the
            // local coordinate system of the MovieClip (i.e. scale factors and
            // other transformations are not taken into account).
            var bounds :Object = active.getBounds( active );
            var bitmap :BitmapData = new BitmapData(
               bounds[ "xMax" ],
               bounds[ "yMax" ],
               true,
               0
            );

            // We use a ColorTransform which sets the alpha value of all drawn
            // pixels to 255 in order to behave like onRollOver/onRollOut and
            // detect areas with _alpha = 0.
            bitmap.draw(
               active,
               new Matrix(),
               new ColorTransform( 1, 1, 1, 1, 0, 0, 0, 255 )
            );

            over = bitmap.hitTest(
               new Point( 0, 0 ),
               0,
               McUtils.globalToLocal( active, globalPosition ).getFlashPoint()
            );
            bitmap.dispose();
         }

         if ( over && !currentArea.currentlyOver ) {
            currentArea.currentlyOver = true;
            currentArea.overHandler();
         } else if ( !over && currentArea.currentlyOver ) {
            currentArea.currentlyOver = false;
            currentArea.outHandler();
         }
      }
   }

   private static var m_instance :MouseoverManager;

   private var m_areas :Array;
   private var m_clip :MovieClip;
}
