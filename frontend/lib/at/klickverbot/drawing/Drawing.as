import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.ui.clips.BitmapCachedDrawing;
import at.klickverbot.util.DummyClipManager;

import flash.geom.Point;

class at.klickverbot.drawing.Drawing extends CoreObject {
   /**
    * Constructor.
    */
   public function Drawing() {
      m_operations = new Array();
   }

   public function addOperation( op :IDrawingOperation ) :Void {
      m_operations.push( op );
   }
   public function getOperations() :Array {
      return m_operations.slice();
   }
   public function getNumPoints() :Number {
      var numPoints :Number = 0;

      for ( var i :Number = 0; i < m_operations.length; ++i ) {
         numPoints += IDrawingOperation( m_operations[ i ] ).getNumPoints();
      }

      return numPoints;
   }

   // Currently unused, has to be updated with the new algorithm (see eraseWithKey).
   //	public function eraseAt( pressPoint :Point2D, releasePoint :Point2D ) :Void;

   public function eraseWithKey( pressPoint :Point2D, releasePoint :Point2D,
      key :Drawing, eraseKey :Boolean, fuzzy :Number ) :Boolean {

      initEraseTestClip();

      if ( eraseKey == null ) {
         eraseKey = false;
      }
      if ( fuzzy == null ) {
         fuzzy = 0;
      }

      if ( key.m_operations.length != m_operations.length ) {
         Debug.LIBRARY_LOG.warn( "Can't erase using a key drawing with " +
            "a different operation count." );
         return false;
      }

      var pressFp :Point = pressPoint.getFlashPoint();
      var releaseFp :Point = releasePoint.getFlashPoint();

      var currentOperation :IDrawingOperation;
      var operationIndex :Number = key.m_operations.length;

      while ( currentOperation = key.m_operations[ --operationIndex ] ) {
         // If the mouse was not pressed in the bounding box of the current
         // operation, we can skip any further tests.
         if ( currentOperation.getAffectedArea().containsPoint( pressPoint ) ) {
            continue;
         }

         currentOperation.draw( m_eraseTestClip );

         if ( m_eraseTestClip.hitTestDrawn( pressFp ) ) {
            // If both the click and the release point are in the current
            // operation, delete it.
            if ( m_eraseTestClip.hitTestDrawn( releaseFp ) ) {
               m_operations.splice( operationIndex, 1 );

               // Delete the corresponding operation in the key drawing only
               // if eraseKey was specified.
               if ( eraseKey ) {
                  key.m_operations.splice( operationIndex, 1 );
               }

               disposeEraseTestClip();
               return true;
            }

            // Exit the loop if the press point was in the current operation,
            // regardless whether the operation was actually deleted or not.
            break;
         }
      }

      // If "fuzzy" erasing is used and the first pass was not sucessfull
      // (otherwise the function would have already been left), do a second pass
      // with the broadened operations.
      if ( fuzzy > 0 ) {
         m_eraseTestClip.clear();

         var expandedStyle :LineStyle;
         var expandedOp :IDrawingOperation;

         operationIndex = key.m_operations.length;
         while ( currentOperation = key.m_operations[ --operationIndex ] ) {
            expandedOp = currentOperation.clone();
            expandedStyle = expandedOp.getStyle();
            expandedStyle.thickness += fuzzy;
            expandedOp.setStyle( expandedStyle );
            expandedOp.draw( m_eraseTestClip );

            if ( m_eraseTestClip.hitTestDrawn( pressFp ) ) {
               if ( m_eraseTestClip.hitTestDrawn( releaseFp ) ) {
                  m_operations.splice( operationIndex, 1 );
                  if ( eraseKey ) {
                     key.m_operations.splice( operationIndex, 1 );
                  }

                  disposeEraseTestClip();
                  return true;
               }
               break;
            }
         }
      }

      disposeEraseTestClip();
      return false;
   }


   public function optimize( optimizer :IOperationOptimizer ) :Void {
      for ( var i :Number = 0; i < m_operations.length; ++i ) {
         m_operations[ i ] = optimizer.optimize( m_operations[ i ] );
      }
   }

   public function optimizeToNew( optimizer :IOperationOptimizer ) :Drawing {
      var result :Drawing = new Drawing();

      for ( var i :Number = 0; i < m_operations.length; ++i ) {
         result.m_operations.push(
            optimizer.optimize( IDrawingOperation( m_operations[ i ] ) ) );
      }

      return result;
   }

   public function draw( target :MovieClip ) :Void {
      for ( var i :Number = 0; i < m_operations.length; ++i ) {
         IDrawingOperation( m_operations[ i ] ).draw( target );
      }
   }

   public function clear() :Void {
      m_operations = new Array();
   }

   /**
    * Creates a copy of this object.
    *
    * @param deep Speciefies if a shallow or a deep copy will be created.
    *        Defaults to true (deep).
    * @return The copied object.
    */
   public function clone( deep :Boolean ) :Drawing {
      if ( deep == null ) {
         deep = true;
      }

      var copy :Drawing = new Drawing();

      if ( deep ) {
         for ( var i :Number = 0; i < m_operations.length; ++i ) {
            copy.m_operations.push( IDrawingOperation( m_operations[ i ] ).clone() );
         }
      } else {
         for ( var i :Number = 0; i < m_operations.length; ++i ) {
            copy.m_operations.push( m_operations[ i ] );
         }
      }

      return copy;
   }

   private function initEraseTestClip() :Void {
      m_eraseTestContainer = DummyClipManager.getInstance().createClip();
      m_eraseTestClip = BitmapCachedDrawing.create( m_eraseTestContainer );
   }

   private function disposeEraseTestClip() :Void {
      m_eraseTestClip.removeMovieClip();
      m_eraseTestContainer.removeMovieClip();
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_operations.length + " operations" );
   }

   private var m_operations :Array;

   private var m_eraseTestContainer :MovieClip;
   private var m_eraseTestClip :BitmapCachedDrawing;
}
