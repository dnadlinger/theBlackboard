import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.drawing.Drawing;
import at.klickverbot.drawing.FillStyle;
import at.klickverbot.drawing.IDrawingOperation;
import at.klickverbot.drawing.IOperationOptimizer;
import at.klickverbot.drawing.LineOperation;
import at.klickverbot.drawing.LineStyle;
import at.klickverbot.drawing.NullOptimizer;
import at.klickverbot.drawing.Point2D;
import at.klickverbot.drawing.Rect2D;
import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.event.MixinDispatcher;
import at.klickverbot.event.events.DrawingAreaEvent;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.clips.BitmapCachedDrawing;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.ui.components.drawingArea.DrawingTool;
import at.klickverbot.ui.components.drawingArea.HistoryStack;
import at.klickverbot.ui.components.drawingArea.HistoryStep;
import at.klickverbot.util.Delegate;
import at.klickverbot.util.IMouseListener;

// TODO: Refactor auto drawing code out into a new class?

/**
 * An UiComponent where the user can draw into.
 * Tools: pen (custom color and size), eraser (deletes the clicked line).
 */
class at.klickverbot.ui.components.drawingArea.DrawingArea extends McComponent
   implements IUiComponent, IEventDispatcher {

   /**
    * Constructor.
    *
    * @param optimizer The OperationOptimizer that is used after the user has
    *        finished a line. null to use default (NullOptimizer).
    * @param smoother The OperationOptimizer that is used when a line is
    *        displayed (also on loaded operations). null to use default
    *        (NullOptimizer).
    */
   public function DrawingArea( optimizer :IOperationOptimizer,
      smoother :IOperationOptimizer ) {
      super();

      // Use the NullOptimizer as the default optimizer – does not opzimize
      // anything by default.
      if ( optimizer == null ) {
         optimizer = new NullOptimizer();
      }
      m_optimizer = optimizer;

      // Use the NullOptimizer as the default smoother – no smoothing
      // per default.
      if ( smoother == null ) {
         smoother = new NullOptimizer();
      }
      m_smoother = smoother;

      m_history = new HistoryStack();

      m_tempLine = new LineOperation();
      m_drawMode = false;
      m_clipRect = new Rect2D();

      // Set the pen as the default tool.
      m_currentTool = DrawingTool.PEN;

      // Set the pen style to the default line style (0pt, black, 100%).
      m_penStyle = new LineStyle();

      // Set the preview style to a translucent grey line. Thickness is not
      // important here because later it is overwritten with the correct
      // thickness anyway.
      m_previewStyle = new LineStyle( 0, 0x999999, 0.5 );

      // Do not use the preview style per default.
      m_usePreviewStyleForPen = false;

      // Set the unsmoothed style to a translucent grey line, but do not draw
      // the unsmoothed operations per default.
      m_unsmoothedStyle = new LineStyle( 0, 0x999999, 0.5 );
      m_drawUnsmoothed = false;

      // Make border and background invisible per default.
      m_backgroundStyle = new FillStyle( 0xCCCCCC, 0 );
      m_borderStyle = new LineStyle( 1, 0x555577, 0 );

      m_mouseDrawMode = false;
      m_mouseDrawModePaused = false;

      m_mouseListener = new IMouseListener();
      m_mouseListener.onMouseDown = Delegate.create( this, onMouseDown );

      m_dispatcher = new MixinDispatcher();
      m_dispatcher.overwriteMethods( this );
   }

   //--------------------------------------------------------------------------
   // IUiComponent functions
   //--------------------------------------------------------------------------

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }
      m_finalDrawing = BitmapCachedDrawing.create( m_container );
      m_tempDrawing = BitmapCachedDrawing.create( m_container );

      m_eraserTestClip = m_container.createEmptyMovieClip( "eraserTestClip",
         m_container.getNextHighestDepth() );

      m_background = m_container.createEmptyMovieClip( "background",
         m_container.getNextHighestDepth() );
      drawBorderAndBackground();

      return true;
   }

   /**
    * Destroys the visible part of the component.
    * It can be recreated using @link{ #create }.
    */
   public function destroy() :Void {
      if ( m_onStage ) {
         m_tempDrawing.removeMovieClip();
         m_tempDrawing = null;

         m_finalDrawing.removeMovieClip();
         m_finalDrawing = null;
      }
      super.destroy();
   }

   /**
    * Resizes the component, which sets the bounds for future drawing actions.
    * Already drawn elements are not affected.
    * Drawing actions in the negative coordinate region (to the top and left of
    * the current position) are always discarded.
    *
    * @param width The active area's width.
    * @param heigth The active area's height.
    */
   public function resize( width :Number, height :Number ) :Void {
      Debug.assertLess( 0, width, "The drawing area's width must be larger than 0!" );
      Debug.assertLess( 0, width, "The drawing area's height must be larger than 0!" );

      // TODO: If the drawing area is shrinked, the result may be larger than the specified values. This might cause problems in layout.

      m_clipRect.setRight( width );
      m_clipRect.setBottom( height );
      drawBorderAndBackground();
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      resize( getSize().x * xScaleFactor, getSize().y * yScaleFactor );
   }

   //--------------------------------------------------------------------------
   // Drawing functions
   //--------------------------------------------------------------------------

   /**
    * Starts to draw at the specified position. After that you can draw to new
    * points using drawTo.
    *
    * @param xPos The x-coordinate of the position where to start drawing.
    * @param yPos The y-coordinate of the position where to start drawing.
    * @return If drawing could be started (fails if already drawing or the
    *         stating point is not inside the clipping area).
    */
   public function startLine( xPos :Number, yPos :Number ) :Boolean {
      if ( m_drawMode ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Attempted to start drawing mode, but already started!");
         return false;
      }

      var startPoint :Point2D = new Point2D( xPos, yPos );

      if ( !checkSizeLimit( startPoint ) ) {
         // Point not inside specified area, so drop it. This makes restricting
         // mouse draw to a certain area very easy becaus this function drops
         // the points automatically.
         return false;
      }
      m_drawMode = true;

      m_tempLine = new LineOperation();

      if ( m_currentTool == DrawingTool.PEN ) {
         if ( m_usePreviewStyleForPen ) {
            m_previewStyle.thickness = m_penStyle.thickness;
            m_tempLine.setStyle( m_previewStyle );
         } else {
            m_tempLine.setStyle( m_penStyle );
         }
      }

      m_tempLine.addPoint( startPoint );

      // Do not draw the line for the eraser tool, nasty hack...
      if ( m_onStage && ( m_currentTool != DrawingTool.ERASER ) ) {
         m_tempLine.draw( m_tempDrawing );
      }

      return true;
   }

   /**
    * Draws a line from the current position to the specified point using
    * the current tool.
    *
    * @param xPos The x-coordinate of the point to draw to.
    * @param yPos The y-coordinate of the point to draw to.
    * @return If the line could be drawn (i.e. if a line has been started and
    *         the target point lies inside the borders).
    */
   public function drawTo( xPos :Number, yPos :Number ) :Boolean {
      if ( !m_drawMode ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Attempted to draw, but not currently in drawing mode!" );
         return false;
      }

      var newPoint :Point2D = new Point2D( xPos, yPos );

      if ( !checkSizeLimit( newPoint ) ) {
         return false;
      }

      m_tempLine.addPoint( newPoint );

      // Do not draw the line for the eraser tool, nasty hack...
      if ( m_onStage && ( m_currentTool != DrawingTool.ERASER ) ) {
         m_tempLine.drawPart( -2, null, m_tempDrawing );
      }

      return true;
   }

   /**
    * Draws a line from the current position to the specified point using
    * the current tool.
    *
    * @param targetPoint The point to draw to.
    * @return If the line could be drawn (i.e. if a line has been started and
    *         the target point lies inside the borders).
    */
   public function drawToPoint( targetPoint :Point2D ) :Boolean {
      return drawTo( targetPoint.x, targetPoint.y );
   }

   /**
    * Ends the drawing mode.
    * Finishes the current drawing step: optimizes and smoothes the line using
    * the active IOperationOptimizers, calculates the eraser if active and makes
    * a new undo step.
    * When ready, a OP_COMPLETED-DrawingAreaEvent is broadcast.
    *
    * @return If the line could be finished (the only reason to fail is that
    *         it was not started).
    */
   public function endLine() :Boolean {
      if ( !m_drawMode ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Attempted to end drawing mode, but not currently drawing!" );
         return false;
      }

      var currentStep :HistoryStep = m_history.getCurrent();
      var newDrawing :Drawing = currentStep.drawing.clone( false );
      var newSmoothedDrawing :Drawing;

      if ( m_currentTool == DrawingTool.PEN ) {
         if ( m_tempLine.getNumPoints() > 1 ) {

            // Optimize the new operation, ...
            var optimizedOp :IDrawingOperation = m_optimizer.optimize( m_tempLine );

            // If we were using the preview line style, we have to change it to
            // the correct style.
            if ( m_usePreviewStyleForPen ) {
               optimizedOp.setStyle( m_penStyle.clone() );
            }

            // ... add it to the new drawing, ...
            newDrawing.addOperation( optimizedOp );

            // ... smooth it, ...
            var smoothedOp :IDrawingOperation = m_smoother.optimize( optimizedOp );

            // ... and add the smoothed version to the new smoothed drawing.
            newSmoothedDrawing = currentStep.smoothedDrawing.clone( false );
            newSmoothedDrawing.addOperation( smoothedOp );

            // Then draw it to the screen.
            drawStep( optimizedOp, smoothedOp );

            // Finally, make a new history step with the two version of the
            // operation and add it to the history.
            m_history.addStep( new HistoryStep( newDrawing, newSmoothedDrawing ) );
         }

         // Clear the temporary line.
         m_tempDrawing.clear();

      } else if ( m_currentTool == DrawingTool.ERASER ) {
         // Calculate the points where the mouse was clicked and released.
         var tempLinePoints :Array = m_tempLine.getPoints();
         var pressPoint :Point2D = tempLinePoints[ 0 ];
         var releasePoint :Point2D = tempLinePoints[ tempLinePoints.length - 1 ];

         // Unfortunately, we cannot erase in the unsmoothed drawing directly
         // because it does not match what the user has clicked on the screen.
         newSmoothedDrawing = currentStep.smoothedDrawing.clone();
         if ( newDrawing.eraseWithKey( pressPoint, releasePoint,
            newSmoothedDrawing, true, 5 ) ) {

            // Add the new drawing to the history.
            m_history.addStep( new HistoryStep( newDrawing, newSmoothedDrawing ) );

            // Draw the "new" smoothed drawing to the screen.
            redrawFinalDrawing();
         }

         // We do not need to clear the temporary drawing here, because it is
         // not used in eraser mode.
      }


      // Order *could* be important here if any event reciver wants to draw...
      m_drawMode = false;
      dispatchEvent( new DrawingAreaEvent( DrawingAreaEvent.OP_COMPLETED,
         this, getUndoStepsPossible(),	getRedoStepsPossible() ) );

      return true;
   }

   /**
    * Clears the drawing.
    * Note that the history is <strong>not</strong> cleared, but a empty drawing
    * is added as the last step.
    * When completed, a OP_COMPLETED-DrawingAreaEvent is broadcast.
    *
    * @return If the drawing could be cleared (not possible while in drawing).
    */
   public function clear() :Boolean {
      if ( m_drawMode ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Cannot clear drawing while drawing mode is active!" );
         return false;
      }
      m_finalDrawing.clear();

      m_history.addStep( new HistoryStep( new Drawing(), new Drawing() ) );

      dispatchEvent( new DrawingAreaEvent( DrawingAreaEvent.OP_COMPLETED,
         this, 0, getUndoStepsPossible(),	getRedoStepsPossible() ) );

      return true;
   }

   /**
    * Undoes the specified number of history steps if possible.
    *
    * @param steps The number of steps. Must be <=
    *         <code>getUndoStepsPossible()</code>.
    * @return If the steps could be undone.
    */
   public function undo( steps :Number ) :Boolean {
      if ( m_drawMode ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "Cannot undo while drawing!" );
         return false;
      }
      if ( !m_history.undo( steps ) ) {
         return false;
      }

      redrawFinalDrawing();

      dispatchEvent( new DrawingAreaEvent( DrawingAreaEvent.HISTORY_CHANGE,
         this, getUndoStepsPossible(), getRedoStepsPossible() ) );

      return true;
   }

   /**
    * Redoes the specified number of history steps if possible.
    *
    * @param steps The number of steps. Must be <=
    *         <code>getRedoStepsPossible()</code>.
    * @return If the steps could be redone.
    */
   public function redo( steps :Number ) :Boolean {
      if ( m_drawMode ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN, "Cannot redo while drawing!" );
         return false;
      }
      if ( !m_history.redo( steps ) ) {
         return false;
      }

      redrawFinalDrawing();

      dispatchEvent( new DrawingAreaEvent( DrawingAreaEvent.HISTORY_CHANGE,
         this, getUndoStepsPossible(), getRedoStepsPossible() ) );

      return true;
   }

   /**
    * Clears the current drawing and emptys the history.
    *
    * @return If the history could be cleared (not possible while drawing).
    */
   public function clearHistory() :Boolean {
      if ( m_drawMode ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Cannot clear the drawing while drawing!" );
         return false;
      }

      m_finalDrawing.clear();
      m_history.clear();

      return true;
   }

   public function getUndoStepsPossible() :Number {
      return m_history.getUndoStepsPossible();
   }

   public function getRedoStepsPossible() :Number {
      return m_history.getRedoStepsPossible();
   }

   public function getMouseDrawMode() :Boolean {
      return m_mouseDrawMode;
   }
   public function setMouseDrawMode( mouseDraw :Boolean ) :Boolean {
      if ( !m_onStage ) {
         Debug.LIBRARY_LOG.log( LogLevel.WARN,
            "Cannot switch to mouse drawing mode when not on stage!" );
         return false;
      }

      if ( mouseDraw && !m_mouseDrawMode ) {
         Mouse.addListener( m_mouseListener );
      } else if ( !mouseDraw && m_mouseDrawMode ) {
         Mouse.removeListener( m_mouseListener );
      }
      m_mouseDrawMode = mouseDraw;

      return true;
   }

   public function getActiveTool() :DrawingTool {
      return m_currentTool;
   }

   public function setActiveTool( tool :DrawingTool ) :Void {
      Debug.assert( !m_drawMode,
         "Cannot change drawing tool while drawing!" );
      m_currentTool = tool;
   }

   public function getCurrentDrawing() :Drawing {
      return m_history.getCurrent().drawing;
   }

   public function loadDrawing( newDrawing :Drawing ) :Boolean {
      if ( m_drawMode ) {
         Debug.LIBRARY_LOG.warn( "Cannot load new drawing while in drawing mode!" );
         return false;
      }

      clearHistory();

      var newSmoothedDrawing :Drawing = newDrawing.optimizeToNew( m_smoother );
      newSmoothedDrawing.draw( m_finalDrawing );

      m_history.addStep( new HistoryStep( newDrawing, newSmoothedDrawing ) );

      dispatchEvent( new DrawingAreaEvent( DrawingAreaEvent.HISTORY_CHANGE,
         this, 1, 0 ) );

      return true;
   }


   public function get optimizer() :IOperationOptimizer {
      return m_optimizer;
   }
   public function set optimizer( to :IOperationOptimizer ) :Void {
      m_optimizer = to;
   }

   public function get smoother() :IOperationOptimizer {
      return m_smoother;
   }
   public function set smoother( to :IOperationOptimizer ) :Void {
      m_smoother = to;
   }


   public function get penStyle() :LineStyle {
      return m_penStyle;
   }
   public function set penStyle( to :LineStyle ) :Void {
      m_penStyle = to;
   }

   public function get previewStyle() :LineStyle {
      return m_previewStyle;
   }
   public function set previewStyle( to :LineStyle ) :Void {
      m_previewStyle = to;
   }

   public function get usePreviewStyleForPen() :Boolean {
      return m_usePreviewStyleForPen;
   }
   public function set usePreviewStyleForPen( to :Boolean ) :Void {
      m_usePreviewStyleForPen = to;
   }

   public function get unsmoothedStyle() :LineStyle {
      return m_unsmoothedStyle;
   }
   public function set unsmoothedStyle( to :LineStyle ) :Void {
      m_unsmoothedStyle = to;
   }

   public function get drawUnsmoothed() :Boolean {
      return m_drawUnsmoothed;
   }
   public function set drawUnsmoothed( to :Boolean ) :Void {
      m_drawUnsmoothed = to;
      redrawFinalDrawing();
   }


   public function get backgroundStyle() :FillStyle {
      return m_backgroundStyle;
   }
   public function set backgroundStyle( to :FillStyle ) :Void {
      m_backgroundStyle = to;
      // We have to update the border and the background here!
      drawBorderAndBackground();
   }

   public function get borderStyle() :LineStyle {
      return m_borderStyle;
   }
   public function set borderStyle( to :LineStyle ) :Void {
      m_borderStyle = to;
      // We have to update the border and the background here!
      drawBorderAndBackground();
   }

   // The IEventDispatcer methods will be overwritten by the MixinDispatcher.
   // Only here to satisfy the compiler.
   public function addEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Void {
   }

   public function removeEventListener( eventType :String, listenerOwner :Object,
      listener :Function ) :Boolean {
      return null;
   }

   public function getListenerCount( eventType :String ) :Number {
      return null;
   }

   public function dispatchEvent( event :Event ) :Void {
   }

   /**
    * Helper function that checks if the specified point lies inside the
    * clipping area if there is any set.
    */
   private function checkSizeLimit( point :Point2D ) :Boolean {
      return m_clipRect.containsPoint( point );
   }

   /**
    * Helper function that draws the drawing area border & background on stage.
    */
   private function drawBorderAndBackground() :Void {
      m_background.clear();

      m_borderStyle.setTargetStyle( m_background );
      m_backgroundStyle.beginFillAtTarget( m_background );

      m_background.lineTo( m_clipRect.getWidth(), 0 );
      m_background.lineTo( m_clipRect.getWidth(), m_clipRect.getHeight() );
      m_background.lineTo( 0, m_clipRect.getHeight() );

      m_background.endFill();
   }

   /**
    * Helper function that clears the final drawing and draws the current
    * history step.
    */
   private function redrawFinalDrawing() :Void {
      m_finalDrawing.clear();

      // If drawing the unsmoothed operations is activated, draw them first so
      // they are in the background.
      if ( m_drawUnsmoothed ) {
         var unsmoothedOps :Array = m_history.getCurrent().drawing.getOperations();
         var unsmoothedOp :IDrawingOperation;
         for ( var i :Number = 0; i < unsmoothedOps.length; ++i ) {
            unsmoothedOp = IDrawingOperation( unsmoothedOps[ i ] ).clone();
            unsmoothedOp.setStyle( m_unsmoothedStyle );
            unsmoothedOp.draw( m_finalDrawing );
         }
      }
      m_history.getCurrent().smoothedDrawing.draw( m_finalDrawing );
   }

   /**
    * Helper function that draws a "step" consisting of an unsmoothed and a
    * smoothed drawing operation to the final drawing.
    */
   private function drawStep( operation :IDrawingOperation,
      smoothedOperation :IDrawingOperation ) :Void {

      // If drawing the unsmoothed operations is activated, draw it first so it
      // is in the background.
      if ( m_drawUnsmoothed ) {
         var unsmoothedOperation :IDrawingOperation = operation.clone();
         unsmoothedOperation.setStyle( m_unsmoothedStyle );
         unsmoothedOperation.draw( m_finalDrawing );
      }

      smoothedOperation.draw( m_finalDrawing );
   }

   //--------------------------------------------------------------------------
   // Helper functions for auto mouse drawing mode.
   //--------------------------------------------------------------------------

   private function onMouseDown() :Void {
      if ( m_mouseDrawMode ) {
         if ( m_clipRect.containsPoint( new Point2D( m_container._xmouse,
            m_container._ymouse ) ) ) {

            startLine( m_container._xmouse, m_container._ymouse );
            m_mouseListener.onMouseMove = Delegate.create( this, onMouseMove );
            m_mouseListener.onMouseUp = Delegate.create( this, onMouseUp );
         }
      }
   }

   private function onMouseMove() :Void {
      var pointerX :Number = m_container._xmouse;
      var pointerY :Number = m_container._ymouse;

      // FIXME: This simple logic fails if the mouse button is released unnoticed
      // by flash. This happens if it is released while the mouse is over
      // another window.

      // If currently drawing, simple draw a line to the current mouse position,
      // if drawing is paused (if the mouse was moved out of the area but the
      // mouse button was stil pressed), start drawing again.
      if ( m_drawMode ) {
         var couldDraw :Boolean = drawTo( pointerX, pointerY );

         if( !couldDraw ) {
            var currentPoint :Point2D =
               new Point2D( pointerX, pointerY );
            var lastPoint :Point2D =
               m_tempLine.getPoints()[ m_tempLine.getNumPoints() - 1 ];

            var difference :Point2D = currentPoint.subtractToNew( lastPoint );
            // TODO: Make threshold configurable?
            if ( difference.getSqrLength() >	INTERPOLATE_BORDER_POINT_LIMIT ) {
               if ( ( pointerX < 0 ) || ( pointerX > m_clipRect.getWidth() ) ) {
                  var slope :Number = difference.y / difference.x;

                  if ( pointerX < 0 ) {
                     currentPoint.x = 0;
                  } else {
                     currentPoint.x = m_clipRect.getWidth();
                  }

                  difference = currentPoint.subtractToNew( lastPoint );
                  currentPoint.y = lastPoint.y + difference.x * slope;
               }

               if ( ( pointerY < 0 ) || ( pointerY > m_clipRect.getHeight() ) ) {
                  var reziprocalSlope :Number = difference.x / difference.y;

                  if ( pointerY < 0 ) {
                     currentPoint.y = 0;
                  } else {
                     currentPoint.y = m_clipRect.getHeight();
                  }

                  difference = currentPoint.subtractToNew( lastPoint );
                  currentPoint.x = lastPoint.x + difference.y * reziprocalSlope;
               }
            }

            drawTo( currentPoint.x, currentPoint.y );

            endLine();
            m_mouseDrawModePaused = true;
         }
      } else if ( m_mouseDrawModePaused ) {
         // Continue pausing if the point could not be drawn (the pointer is not
         // yet back inside the drawing area).
         // TODO: Add logic for interpolating the point to be accurately on the border.
         m_mouseDrawModePaused = !startLine( pointerX, pointerY );
      }
      updateAfterEvent();
   }

   private function onMouseUp() :Void {
      if ( m_drawMode ) {
         endLine();
      } else if ( m_mouseDrawModePaused ) {
         m_mouseDrawModePaused = false;
      }
      delete m_mouseListener.onMouseMove;
      delete m_mouseListener.onMouseUp;
   }

   private static var INTERPOLATE_BORDER_POINT_LIMIT :Number = 10;

   private var m_history :HistoryStack;

   private var m_optimizer :IOperationOptimizer;
   private var m_smoother :IOperationOptimizer;

   private var m_tempLine :LineOperation;
   private var m_drawMode :Boolean;
   private var m_clipRect :Rect2D;

   private var m_currentTool :DrawingTool;
   private var m_penStyle :LineStyle;
   private var m_previewStyle :LineStyle;
   private var m_usePreviewStyleForPen :Boolean;

   private var m_drawUnsmoothed :Boolean;
   private var m_unsmoothedStyle :LineStyle;

   private var m_eraserTestClip :MovieClip;

   private var m_mouseDrawMode :Boolean;
   private var m_mouseDrawModePaused :Boolean;
   private var m_mouseListener :IMouseListener;

   private var m_tempDrawing :BitmapCachedDrawing;
   private var m_finalDrawing :BitmapCachedDrawing;
   private var m_background :MovieClip;

   private var m_backgroundStyle :FillStyle;
   private var m_borderStyle :LineStyle;

   private var m_dispatcher :MixinDispatcher;
}
