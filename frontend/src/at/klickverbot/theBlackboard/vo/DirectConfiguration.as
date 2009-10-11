import at.klickverbot.theBlackboard.business.ServiceLocation;
import at.klickverbot.theBlackboard.vo.Configuration;

class at.klickverbot.theBlackboard.vo.DirectConfiguration extends Configuration {
   public function setAvailableThemes( to :Array ) :Void {
      m_availableThemes = to;
   }

   public function setDefaultTheme( to :String ) :Void {
      m_defaultTheme = to;
   }

   public function setDrawingSize( to :Number ) :Void {
      m_drawingSize = to;
   }

   public function setEntryPreloadLimit( to :Number ) :Void {
      m_entryPreloadLimit = to;
   }

   public function setEntryServiceLocation( to :ServiceLocation ) :Void {
      m_entryServiceLocation = to;
   }
}
