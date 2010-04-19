import at.klickverbot.debug.Debug;
import at.klickverbot.data.ICollection;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.CollectionEvent;

class at.klickverbot.data.List extends EventDispatcher
   implements ICollection {

   public function List() {
      m_data = new Array();
   }

   public function push( newItem :Object ) :Void {
      m_data.push( newItem );
      dispatchChangeEvent();
   }

   public function remove( item :Object ) :Boolean {
      if ( item == null ) {
         Debug.LIBRARY_LOG.debug( "Attempted to remove null item from: " + this );
         return false;
      }

      var currentItem :Object;
      var i :Number = m_data.length;
      while ( currentItem = m_data[ --i ] ) {
         if ( currentItem === item ) {
            m_data.splice( i, 1 );
            dispatchChangeEvent();
            return true;
         }
      }

      return false;
   }

   public function removeFirst() :Object {
      var value :Object = m_data.shift();
      dispatchChangeEvent();
      return value;
   }

   public function removeLast() :Object {
      var value :Object = m_data.pop();
      dispatchChangeEvent();
      return value;
   }

   public function removeAll() :Void {
      m_data = new Array();
      dispatchChangeEvent();
   }

   public function getItemAt( position :Number ) :Object {
      return m_data[ position ];
   }

   public function getFirst() :Object {
      return getItemAt( 0 );
   }

   public function getLast() :Object {
      return getItemAt( getLength() - 1 );
   }

   public function getAll() :Array {
      return m_data.slice();
   }

   public function fromArray( source :Array ) :Void {
      m_data = source.slice();
      dispatchChangeEvent();
   }

   public function getLength() :Number {
      return m_data.length;
   }

   public function setData( data: Array ) :Void {
      m_data = data;
      dispatchChangeEvent();
   }

   private function dispatchChangeEvent() :Void {
      dispatchEvent( new CollectionEvent( CollectionEvent.CHANGE, this ) );
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "data: " + m_data );
   }

   private var m_data :Array;
}
