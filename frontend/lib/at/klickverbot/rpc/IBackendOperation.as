import at.klickverbot.rpc.IOperation;

interface at.klickverbot.rpc.IBackendOperation extends IOperation {
   public function getBackendMethodId() :String;
}
