import at.klickverbot.core.ICoreInterface;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;

interface at.klickverbot.cairngorm.business.IResponder extends ICoreInterface {
   public function onResult( data :ResultEvent ) :Void;
   public function onFault( info :FaultEvent ) :Void;
}
