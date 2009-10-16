import at.klickverbot.event.IEventDispatcher;

interface at.klickverbot.ui.animation.IAnimation extends IEventDispatcher {
	public function tick( deltaTime :Number ) :Number;
	public function end() :Void;
	public function isCompleted() :Boolean;
	public function rewind() :Void;
}
