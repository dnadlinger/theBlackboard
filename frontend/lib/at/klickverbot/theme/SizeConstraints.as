import at.klickverbot.core.CoreObject;

class at.klickverbot.theme.SizeConstraints extends CoreObject {
   public function SizeConstraints( minWidth :Number, minHeight :Number,
      maxWidth :Number, maxHeight :Number ) {
      m_minWidth = minWidth;
      m_minHeight = minHeight;
      m_maxWidth = maxWidth;
      m_maxHeight = maxHeight;
   }

   public function limitWidth( width :Number ) :Number {
      var capped :Number = width;

      if ( !isNaN( m_minWidth ) ) {
         capped = Math.max( capped, m_minWidth );
      }

      if ( !isNaN( m_maxWidth ) ) {
         capped = Math.min( capped, m_maxWidth );
      }

      return capped;
   }

   public function limitHeight( height :Number ) :Number {
      var capped :Number = height;

      if ( !isNaN( m_minHeight ) ) {
         capped = Math.max( capped, m_minWidth );
      }

      if ( !isNaN( m_maxHeight ) ) {
         capped = Math.min( capped, m_maxWidth );
      }

      return capped;
   }

   public function get minWidth() :Number {
      return m_minWidth;
   }
   public function set minWidth( to :Number ) :Void {
      m_minWidth = to;
   }

   public function get minHeight() :Number {
      return m_minHeight;
   }
   public function set minHeight( to :Number ) :Void {
      m_minHeight = to;
   }

   public function get maxWidth() :Number {
      return m_maxWidth;
   }
   public function set maxWidth( to :Number ) :Void {
      m_maxWidth = to;
   }

   public function get maxHeight() :Number {
      return m_maxHeight;
   }
   public function set maxHeight( to :Number ) :Void {
      m_maxHeight = to;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "minWidth: " + m_minWidth, "minHeight: " + m_minHeight,
         "maxWidth: " + m_maxWidth, "maxHeight: " + m_maxHeight
      ] );
   }

   private var m_minWidth :Number;
   private var m_minHeight :Number;
   private var m_maxWidth :Number;
   private var m_maxHeight :Number;
}
