import at.klickverbot.debug.Logger;
import at.klickverbot.theBlackboard.vo.EntriesSortingType;
import at.klickverbot.theBlackboard.business.EntryDelegate;
import at.klickverbot.theBlackboard.business.ServiceType;
import at.klickverbot.theBlackboard.vo.Configuration;
import at.klickverbot.event.IEventDispatcher;
import at.klickverbot.event.events.Event;
import at.klickverbot.event.events.FaultEvent;
import at.klickverbot.event.events.ResultEvent;
import at.klickverbot.theBlackboard.business.ConfigDelegate;
import at.klickverbot.theBlackboard.business.ConfigLocationDelegate;
import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.model.ApplicationModel;

class at.klickverbot.theBlackboard.controller.ApplicationController {
   /**
    * Constructor.
    */
   public function ApplicationController( model :ApplicationModel ) {
      m_model = model;
   }

   public function listenTo( target :IEventDispatcher ) :Void {
      target.addEventListener( Event.LOAD, this, startApplication );
   }

   private function startApplication( event :Event ) :Void {
      ConfigLocationDelegate.setServiceLocation( CONFIG_LOCATION_SERVICE );

      var delegate :ConfigLocationDelegate = new ConfigLocationDelegate();
      delegate.addEventListener( ResultEvent.RESULT, this, handleConfigLocationResult );
      delegate.addEventListener( FaultEvent.FAULT, this, handleFault );
      delegate.loadConfigLocation();
   }

   private function handleConfigLocationResult( event :ResultEvent ) :Void {
      ConfigDelegate.setServiceLocation( ServiceLocation( event.result ) );

      var delegate :ConfigDelegate = new ConfigDelegate();
      delegate.addEventListener( ResultEvent.RESULT, this, handleConfigResult );
      delegate.addEventListener( FaultEvent.FAULT, this, handleFault );
      delegate.loadConfig();
   }

   private function handleConfigResult( event :ResultEvent ) :Void {
      m_model.configuration = Configuration( event.result );
      EntryDelegate.setServiceLocation( m_model.configuration.entryServiceLocation );

      var delegate :EntryDelegate = new EntryDelegate();
      delegate.addEventListener( ResultEvent.RESULT, this, handleEntriesResult );
      delegate.addEventListener( FaultEvent.FAULT, this, handleFault );
      delegate.getAllEntries( ENTRIES_SORTING_TYPE );
   }

   private function handleEntriesResult( event :ResultEvent ) :Void {
      var entries :Array = Array( event.result );
      Logger.getLog( "ApplicationController" ).info( entries.length +
         " entries loaded." );
      m_model.entries.setData( entries );
   }

   private function handleFault( event :FaultEvent ) :Void {
      m_model.serviceErrors.push( event );
   }

   private static var CONFIG_LOCATION_SERVICE :ServiceLocation =
      new ServiceLocation( ServiceType.PLAIN_XML, "configLocation.xml" );

   private static var ENTRIES_SORTING_TYPE :EntriesSortingType =
      EntriesSortingType.OLD_TO_NEW;

   private var m_model :ApplicationModel;
}
