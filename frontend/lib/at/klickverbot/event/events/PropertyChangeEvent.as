import at.klickverbot.event.events.Event;

/**
 * Base class for property-change events.
 * Note that there are no event types defined in this class. This will be done
 * in the concrete subclasses according to the properties of the class they
 * "belong" to.
 *
 */
class at.klickverbot.event.events.PropertyChangeEvent extends Event {
   public function PropertyChangeEvent( type :String, target :Object,
      oldValue :Object, newValue :Object ) {
      super( type, target );
      m_oldValue = oldValue;
      m_newValue = newValue;
   }

   public function get oldValue() :Object {
      return m_oldValue;
   }

   public function get newValue() :Object {
      return m_newValue;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "oldValue: " + m_oldValue,
         "newValue: " + m_newValue
      ] );
   }

   private var m_oldValue :Object;
   private var m_newValue :Object;
}
