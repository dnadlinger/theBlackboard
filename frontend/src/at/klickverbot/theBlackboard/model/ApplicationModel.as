import at.klickverbot.theBlackboard.vo.Configuration;
import at.klickverbot.theBlackboard.model.ApplicationModelChangeEvent;
import at.klickverbot.data.List;
import at.klickverbot.event.EventDispatcher;

class at.klickverbot.theBlackboard.model.ApplicationModel extends EventDispatcher {
   public function ApplicationModel() {
      super();

      m_configuration = null;
      m_entries = new List();
      m_serviceErrors = new List();
   }

   public function get configuration() :Configuration {
      return m_configuration;
   }

   public function set configuration( to :Configuration ) :Void {
      var oldValue :Configuration = m_configuration;
      if ( oldValue != to ) {
         m_configuration = to;
         dispatchEvent( new ApplicationModelChangeEvent(
            ApplicationModelChangeEvent.CONFIGURATION, this, oldValue, to ) );
      }
   }

   public function get entries() :List {
      return m_entries;
   }

   public function set entries( to :List ) :Void {
      var oldValue :List = m_entries;
      if ( oldValue != to ) {
         m_entries = to;
         dispatchEvent( new ApplicationModelChangeEvent(
            ApplicationModelChangeEvent.ENTRIES, this, oldValue, to ) );
      }
   }

   public function get serviceErrors() :List {
      return m_serviceErrors;
   }

   public function set serviceErrors( to :List ) :Void {
      var oldValue :List = m_serviceErrors;
      if ( oldValue != to ) {
         m_serviceErrors = to;
         dispatchEvent( new ApplicationModelChangeEvent(
            ApplicationModelChangeEvent.SERVICE_ERRORS, this, oldValue, to ) );
      }
   }

   private var m_configuration :Configuration;
   private var m_entries :List;
   private var m_serviceErrors :List;
}
