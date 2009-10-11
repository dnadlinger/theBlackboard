import at.klickverbot.core.CoreMovieClip;

/**
 * Button to use in a theme swf with a clip that is intened to work with the
 * at.klickverbot.ui.themed.Button component.
 *
 * No create here becuase this class doesn't make sense with a dynamically
 * created MovieClip.
 *
 */
class at.klickverbot.ui.clips.DefaultButton extends CoreMovieClip {
   public function activeAni() :Void {
      this.gotoAndPlay( "active" );
   }
   public function inactiveAni() :Void {
      this.gotoAndPlay( "inactive" );
   }
   public function hoverAni() :Void {
      this.gotoAndPlay( "hover" );
   }
   public function pressAni() :Void {
      this.gotoAndPlay( "press" );
   }
   public function releaseAni() :Void {
      this.gotoAndPlay( "hover" );
   }
   public function releaseOutsideAni() :Void {
      this.gotoAndPlay( "active" );
   }
   public function getActiveArea() :MovieClip {
      return this[ "activeArea" ];
   }
}