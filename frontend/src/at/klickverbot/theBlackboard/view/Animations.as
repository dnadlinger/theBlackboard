import at.klickverbot.graphics.Color;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.graphics.Tint;
import at.klickverbot.ui.animation.AlphaTween;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.ui.animation.Compound;
import at.klickverbot.ui.animation.PropertyTween;
import at.klickverbot.ui.animation.Sequence;
import at.klickverbot.ui.animation.TintTween;
import at.klickverbot.ui.animation.timeMapping.TimeMappers;
import at.klickverbot.ui.components.IUiComponent;

class at.klickverbot.theBlackboard.view.Animations {
   public static function fadeIn( component :IUiComponent ) :IAnimation {
      component.fade( 0 );
      return new Animation(
         new AlphaTween( component, 1 ),
         FADE_DURATION,
         TimeMappers.CUBIC
      );
   }

   public static function flash( component :IUiComponent ) :IAnimation {
      return new Sequence( [
         new Animation(
            new TintTween( component, FULL_WHITE, ZERO_WHITE ),
            FADE_DURATION * 0.1,
            TimeMappers.SINE
         ),
         new Animation(
            new TintTween( component, ZERO_WHITE, FULL_WHITE ),
            FADE_DURATION * 0.6,
            TimeMappers.SINE
         )
      ] );
   }

   public static function zoomTo( target :MovieClip,
      position :Point2D, scaleFactor :Number, animate :Boolean ) :IAnimation {

      var duration :Number;
      if ( animate ) {
         duration = FADE_DURATION;
      } else {
         duration = 0;
      }

      var tweens :Array = [
         new PropertyTween( target, "_x", -position.x ),
         new PropertyTween( target, "_y", -position.y ),
         new PropertyTween( target, "_xscale", scaleFactor * 100 ),
         new PropertyTween( target, "_yscale", scaleFactor * 100 )
      ];

      var animations :Array = new Array();
      for ( var i :Number = 0; i < tweens.length; ++i ) {
         animations.push( new Animation( tweens[ i ], duration, TimeMappers.CUBIC ) );
      }

      return new Compound( animations );
   }

   public static var FADE_DURATION :Number = 0.7;
   public static var FULL_WHITE :Tint = new Tint( new Color( 1, 1, 1 ), 0.5 );
   public static var ZERO_WHITE :Tint = new Tint( new Color( 1, 1, 1 ), 0 );
}
