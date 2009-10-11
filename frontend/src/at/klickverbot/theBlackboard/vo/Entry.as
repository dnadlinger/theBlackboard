import at.klickverbot.cairngorm.vo.IValueObject;
import at.klickverbot.drawing.Drawing;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.theBlackboard.vo.EntryChangeEvent;

class at.klickverbot.theBlackboard.vo.Entry extends EventDispatcher
   implements IValueObject {

   public function Entry() {
      m_id = null;
      m_caption = null;
      m_author = null;
      m_drawing = null;
      m_timestamp = null;
      m_loaded = false;
   }

   public function copyFrom( other :Entry ) :Void {
      this.id = other.id;
      this.caption = other.caption;
      this.author = other.author;
      this.drawing = other.drawing;
      this.timestamp = other.timestamp;
      this.loaded = other.loaded;
   }

   public function get id() :Number {
      return m_id;
   }

   public function set id( to :Number ) :Void {
      var oldValue :Number = m_id;
      if ( oldValue != to ) {
         m_id = to;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.ID, this, oldValue, to ) );
      }
   }

   public function get caption() :String {
      return m_caption;
   }

   public function set caption( to :String ) :Void {
      var oldValue :String = m_caption;
      if ( oldValue != to ) {
         m_caption = to;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.CAPTION, this, oldValue, to ) );
      }
   }

   public function get author() :String {
      return m_author;
   }

   public function set author( to :String ) :Void {
      var oldValue :String = m_author;
      if ( oldValue != to ) {
         m_author = to;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.AUTHOR, this, oldValue, to ) );
      }
   }

   public function get drawing() :Drawing {
      return m_drawing;
   }

   public function set drawing( to :Drawing ) :Void {
      var oldValue :Drawing = m_drawing;
      if ( oldValue != to ) {
         m_drawing = to;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.DRAWING, this, oldValue, to ) );
      }
   }

   public function get timestamp() :Date {
      return m_timestamp;
   }

   public function set timestamp( to :Date ) :Void {
      var oldValue :Date = m_timestamp;
      if ( oldValue != to ) {
         m_timestamp = to;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.TIMESTAMP, this, oldValue, to ) );
      }
   }


   public function get loaded() :Boolean {
      return m_loaded;
   }

   public function set loaded( to :Boolean ) :Void {
      var oldValue :Boolean = m_loaded;
      if ( oldValue != to ) {
         m_loaded = to;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.LOADED, this, oldValue, to ) );
      }
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( "id: " + m_id );
   }

   private var m_id :Number;
   private var m_caption :String;
   private var m_author :String;
   private var m_drawing :Drawing;
   private var m_loaded :Boolean;
   private var m_timestamp :Date;
}
