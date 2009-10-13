import at.klickverbot.data.ICollection;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.event.events.CollectionEvent;

class at.klickverbot.data.List extends EventDispatcher
   implements ICollection {

   public function List() {
      m_data = new Array();
   }

   public function addItem( newItem :Object ) :Void {
      m_data.push( newItem );
      dispatchChangeEvent();
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

   public function getFirstItem() :Object {
      return getItemAt( 0 );
   }

   public function getLastItem() :Object {
      return getItemAt( getLength() - 1 );
   }

   public function getAllItems() :Array {
      return m_data.slice();
   }

   public function fromArray( source :Array ) :Void {
      m_data = source.slice();
      dispatchChangeEvent();
   }

   public function getLength() :Number {
      return m_data.length;
   }

   private function dispatchChangeEvent() :Void {
      dispatchEvent( new CollectionEvent( CollectionEvent.CHANGE, this ) );
   }

   private var m_data :Array;
}
