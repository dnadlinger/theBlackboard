import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.commands.SequenceCommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.core.CoreObject;
import at.klickverbot.debug.Debug;

class at.klickverbot.cairngorm.commands.AbstractCommand extends CoreObject
   implements ICommand {

   public function execute( event :CairngormEvent ) :Void {
      Debug.pureVirtualFunctionCall( "AbstractCommand.execute" );
   }

   public function setParent( parentCommand :SequenceCommand ) :Void {
      m_parent = parentCommand;
   }

   private function complete() :Void {
      if ( m_parent != null ) {
         m_parent.childCompleted();
      }
   }

   private function fail() :Void {
      if ( m_parent != null ) {
         m_parent.childFailed();
      }
   }

   private var m_parent :SequenceCommand;
}