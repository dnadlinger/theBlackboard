import at.klickverbot.cairngorm.model.IModelLocator;
import at.klickverbot.data.List;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.theBlackboard.model.ModelChangeEvent;
import at.klickverbot.theBlackboard.vo.ApplicationState;
import at.klickverbot.theBlackboard.vo.Configuration;
import at.klickverbot.theBlackboard.vo.Entry;
import at.klickverbot.theBlackboard.vo.EntrySet;

class at.klickverbot.theBlackboard.model.Model
   extends EventDispatcher implements IModelLocator {

   private function Model() {
      m_config = null;
      m_serviceErrors = new List();
      m_currentEntries = null;
      m_newEntry = null;
      m_selectedEntry = null;
      m_entryUpdatingActive = false;
      m_applicationState = ApplicationState.LOADING;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The instance of BlackboardModel.
    */
   public static function getInstance() :Model {
      if ( m_instance == null ) {
         m_instance = new Model();
      }
      return m_instance;
   }


   public function get config() :Configuration {
      return m_config;
   }
   public function set config( to :Configuration ) :Void {
      var oldValue :Configuration = m_config;
      if ( oldValue != to ) {
         m_config = to;
         dispatchEvent( new ModelChangeEvent( ModelChangeEvent.CONFIG, this,
            oldValue, to ) );
      }
   }

   public function get serviceErrors() :List {
      return m_serviceErrors;
   }
   public function set serviceErrors( to :List ) :Void {
      var oldValue :List = m_serviceErrors;
      if ( oldValue != to ) {
         m_serviceErrors = to;
         dispatchEvent( new ModelChangeEvent( ModelChangeEvent.SERVICE_ERRORS,
            this, oldValue, to ) );
      }
   }

   public function get entryCount() :Number {
      return m_entryCount;
   }
   public function set entryCount( to :Number ) :Void {
      var oldValue :Number = m_entryCount;
      if ( oldValue != to ) {
         m_entryCount = to;
         dispatchEvent( new ModelChangeEvent(
            ModelChangeEvent.ENTRY_COUNT, this, oldValue, to ) );
      }
   }

   public function get currentEntries() :EntrySet {
      return m_currentEntries;
   }
   public function set currentEntries( to :EntrySet ) :Void {
      var oldValue :EntrySet = m_currentEntries;
      if ( oldValue != to ) {
         m_currentEntries = to;
         dispatchEvent( new ModelChangeEvent(
            ModelChangeEvent.CURRENT_ENTRIES, this, oldValue, to ) );
      }
   }

   public function get newEntry() :Entry {
      return m_newEntry;
   }
   public function set newEntry( to :Entry ) :Void {
      var oldValue :Entry = m_newEntry;
      if ( oldValue != to ) {
         m_newEntry = to;
         dispatchEvent( new ModelChangeEvent(
            ModelChangeEvent.NEW_ENTRY, this, oldValue, to ) );
      }
   }

   public function get selectedEntry() :Entry {
      return m_selectedEntry;
   }
   public function set selectedEntry( to :Entry ) :Void {
      var oldValue :Entry = m_selectedEntry;
      if ( oldValue != to ) {
         m_selectedEntry = to;
         dispatchEvent( new ModelChangeEvent(
            ModelChangeEvent.SELECTED_ENTRY, this, oldValue, to ) );
      }
   }

   public function get entryUpdatingActive() :Boolean {
      return m_entryUpdatingActive;
   }
   public function set entryUpdatingActive( to :Boolean ) :Void {
      var oldValue :Boolean = m_entryUpdatingActive;
      if ( oldValue != to ) {
         m_entryUpdatingActive = to;
         dispatchEvent( new ModelChangeEvent(
            ModelChangeEvent.ENTRY_UPDATING_ACTIVE, this, oldValue, to ) );
      }
   }

   public function get applicationState() :ApplicationState {
      return m_applicationState;
   }
   public function set applicationState( to :ApplicationState ) :Void {
      var oldValue :ApplicationState = m_applicationState;
      if ( oldValue != to ) {
         m_applicationState = to;
         dispatchEvent( new ModelChangeEvent(
            ModelChangeEvent.APPLICATION_STATE, this, oldValue, to ) );
      }
   }


   private static var m_instance :Model;

   private var m_config :Configuration;
   private var m_serviceErrors :List;
   private var m_entryCount :Number;
   private var m_currentEntries :EntrySet;
   private var m_newEntry :Entry;
   private var m_selectedEntry :Entry;
   private var m_entryUpdatingActive :Boolean;
   private var m_availableEntriesCount :Number;
   private var m_applicationState :ApplicationState;
}
