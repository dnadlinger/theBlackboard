import at.klickverbot.debug.Logger;
import at.klickverbot.debug.Debug;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.ui.components.themed.Static;

class at.klickverbot.theBlackboard.view.PageDisplay extends Static {
   public function PageDisplay() {
      super( AppClipId.PAGE_DISPLAY );
   }

   private function createUi() :Boolean {
      if ( !super.createUi() ) {
         return false;
      }

      // TODO: Put the name strings into some central enum like ContainerContents?
      m_currentField = TextField( m_staticContent[ "currentPage" ] );
      if ( m_currentField == null ) {
         Logger.getLog( "PageDisplay" ).error(
            "Static content did not contain a current page field for " + this );
         return false;
      }

      m_totalField = TextField( m_staticContent[ "totalPages" ] );
      if ( m_totalField == null ) {
         Logger.getLog( "PageDisplay" ).error(
            "Static content did not contain a total pages field for " + this );
         return false;
      }

      return true;
   }

   public function setCurrentPage( page :Number ) :Void {
      Debug.assert( m_onStage, "Cannot set the current page while not on stage." );
      m_currentField.text = page.toString();
   }

   public function setPageCount( count :Number ) :Void {
      Debug.assert( m_onStage, "Cannot set page count while not on stage." );
      m_totalField.text = count.toString();
   }

   private var m_currentField :TextField;
   private var m_totalField :TextField;
}
