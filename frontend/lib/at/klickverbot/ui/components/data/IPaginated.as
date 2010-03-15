import at.klickverbot.event.IEventDispatcher;

interface at.klickverbot.ui.components.data.IPaginated extends IEventDispatcher {
   public function getCurrentPage() :Number;
   public function getPageCount() :Number;
}
