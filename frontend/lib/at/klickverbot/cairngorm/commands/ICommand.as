import at.klickverbot.cairngorm.commands.SequenceCommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.core.ICoreInterface;

interface at.klickverbot.cairngorm.commands.ICommand extends ICoreInterface {
   public function execute( event :CairngormEvent ) :Void;
   public function setParent( parentCommand :SequenceCommand ) :Void;
}
