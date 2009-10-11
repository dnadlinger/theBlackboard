import at.klickverbot.data.ICollection;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.CollectionEvent;

class at.klickverbot.data.Map extends EventDispatcher
   implements ICollection {

   /**
    * Constructor.
    */
   public function Map() {
      m_data = new Object();
   }

   public function getValue( key :String ) :Object {
      return m_data[ key ];
   }

   public function setValue( key :String, value :Object ) :Void {
      m_data[ key ] = value;
      dispatchChangeEvent();
   }

   public function removeAll() :Void {
      m_data = new Object();
      dispatchChangeEvent();
   }

   public function hasKey( key :String ) :Boolean {
      // TODO: If key's value is set to null or undefined, this is wrong.
      return ( m_data[ key ] != null );
   }

   public function fromObject( source :Object ) :Void {
      m_data = new Object();

      // Make an indepenant copy. Maybe this simple method comes with some
      // pitfalls, but it should suffice in most cases.
      for ( var key :String in source ) {
         m_data[ key ] = source[ key ];
      }

      dispatchChangeEvent();
   }

   private function dispatchChangeEvent() :Void {
      dispatchEvent( new CollectionEvent( CollectionEvent.CHANGE, this ) );
   }

   private var m_data :Object;
}
