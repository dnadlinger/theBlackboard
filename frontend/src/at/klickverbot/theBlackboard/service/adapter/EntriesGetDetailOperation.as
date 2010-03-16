import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.model.Entry;
import at.klickverbot.theBlackboard.service.adapter.AdapterOperation;
import at.klickverbot.theBlackboard.service.adapter.EntryParser;
import at.klickverbot.theBlackboard.service.backend.IEntriesBackend;

class at.klickverbot.theBlackboard.service.adapter.EntriesGetDetailOperation extends AdapterOperation {
   public function EntriesGetDetailOperation( backend :IEntriesBackend,
      target :Entry ) {
      m_target = target;
      super( backend.getEntryById( target.id ) );
   }

   private function handleResult( event :ResultEvent ) :Void {
      var result :Entry = ( new EntryParser() ).parseAA( event.result );
      m_target.copyFrom( result );
      dispatchEvent( new ResultEvent( ResultEvent.RESULT, this, result ) );
   }

   private var m_target :Entry;
}
