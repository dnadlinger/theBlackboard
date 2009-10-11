import at.klickverbot.cairngorm.commands.AbstractCommand;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.debug.Debug;
import at.klickverbot.util.TypeUtils;

class at.klickverbot.cairngorm.commands.SequenceCommand
   extends AbstractCommand implements ICommand {

   public function execute( event :CairngormEvent ) :Void {
      m_event = event;

      m_sequence = new Array();
      initSequence();

      m_currentIndex = 0;
      executeCurrentCommand();
   }

   public function childCompleted() :Void {
      ++m_currentIndex;
      executeCurrentCommand();
   }

   public function childFailed() :Void {
      fail();
   }

   private function initSequence() :Void {
      Debug.pureVirtualFunctionCall( "SequenceCommand.initChildCommands" );
   }

   private function addCommand( commandClass :Function ) :Void {
      m_sequence.push( commandClass );
   }

   private function executeCurrentCommand() :Void {
      if ( m_currentIndex < m_sequence.length ) {
         var commandClass :Function = m_sequence[ m_currentIndex ];

         // Unfortunately we cannot call the constructor with params here so we
         // have to create a setParent()-method and call it here.
         var command :ICommand = new commandClass();
         command.setParent( this );

         command.execute( m_event );
      } else {
         complete();
      }
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat(	"currentCommand: " +
         TypeUtils.getTypeName( m_sequence[ m_currentIndex ] ) +
         " (" + ( m_currentIndex + 1 ) + "/" + m_sequence.length + ")" );
   }

   private var m_sequence :Array;
   private var m_currentIndex :Number;

   private var m_event :CairngormEvent;
}
