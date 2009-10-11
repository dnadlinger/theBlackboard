import at.klickverbot.event.IEventDispatcher;

interface at.klickverbot.rpc.IOperation extends IEventDispatcher {
   public function execute() :Void;
}