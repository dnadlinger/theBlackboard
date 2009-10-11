import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.drawing.Drawing;
import at.klickverbot.ui.components.drawingArea.HistoryAddMode;
import at.klickverbot.ui.components.drawingArea.HistoryStep;

class at.klickverbot.ui.components.drawingArea.HistoryStack extends CoreObject {
   /**
    * Constructor.
    */
   public function HistoryStack() {
      m_buffer = [ new HistoryStep( new Drawing(), new Drawing() ) ];
      m_currentStep = 0;
      m_maxSteps = DEFAULT_SIZE;
      m_addMode = HistoryAddMode.DISCARD_REDO;
   }

   public function addStep( step :HistoryStep ) :Void {
      // Check if there are some redo steps possible that we have to deal with.
      if ( getRedoStepsPossible() > 0 ) {
         if ( m_addMode == HistoryAddMode.DISCARD_REDO ) {
            // Discard all possible redo steps.
            m_buffer.splice( m_currentStep + 1 );
         } else if ( m_addMode == HistoryAddMode.APPEND_AT_END ) {
            // We are going to append the new step at the end of the buffer, so
            // we don't have to discard anything. However, we have to modify
            // the current index "in advance", so that the current step is not
            // changed when the index is incremented at the end.
            // This is not a clean way of doing this, but imho two if tests are
            // not a better solution.
            --m_currentStep;
         }
      }

      // If we have no more space in the buffer, discard the oldest step.
      if ( m_buffer.length == m_maxSteps ) {
         m_buffer.shift();

         // Don't forget to update the current index (all indicies have
         // moved one position towards zero).
         --m_currentStep;
      }

      m_buffer.push( step );
      ++m_currentStep;
   }

   /**
    * Undoes the specified number of history steps if possible.
    *
    * @param steps The number of steps. Must be <=
    *         <code>getUndoStepsPossible()</code>.
    * @return If the steps could be undone.
    */
   public function undo( steps :Number ) :Boolean {
      if ( steps > getUndoStepsPossible() ) {
         Debug.LIBRARY_LOG.log( LogLevel.ERROR,
            "Not so much undo steps available: " + steps );
         return false;
      }
      m_currentStep -= steps;
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
      if ( steps > getRedoStepsPossible() ) {
         Debug.LIBRARY_LOG.log( LogLevel.ERROR,
            "Not so much redo steps available: " + steps );
         return false;
      }
      m_currentStep += steps;
      return true;
   }

   public function clear() :Void {
      m_buffer = [ new HistoryStep( new Drawing(), new Drawing() ) ];
      m_currentStep = 0;
   }

   public function getCurrent() :HistoryStep {
      return m_buffer[ m_currentStep ];
   }


   public function getMaxSize() :Number {
      return m_maxSteps;
   }

   public function setMaxSize( steps :Number ) :Boolean {
      Debug.assertLessOrEqual( 1, steps,
         "Invalid value for history buffer size: " + steps );

      var stepsToRemove :Number = m_buffer.length - steps;
      if ( stepsToRemove > 0 ) {
         if ( m_currentStep < stepsToRemove ) {
            Debug.LIBRARY_LOG.log( LogLevel.WARN, "Cannot change undo buffer" +
               "size because the currently active step would be discarded" );
            return false;
         }
         m_buffer.splice( 0, stepsToRemove );
         m_currentStep -= stepsToRemove;
      }
      m_maxSteps = steps;
      return true;
   }


   public function getUndoStepsPossible() :Number {
      return m_currentStep;
   }

   public function getRedoStepsPossible() :Number {
      return m_buffer.length - 1 - m_currentStep;
   }

   public var DEFAULT_SIZE :Number = 25;

   private var m_currentStep :Number;
   private var m_maxSteps :Number;
   private var m_addMode :HistoryAddMode;

   private var m_buffer :Array;
}