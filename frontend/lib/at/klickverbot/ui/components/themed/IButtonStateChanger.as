interface at.klickverbot.ui.components.themed.IButtonStateChanger {
	public function active() :Void;
	public function inactive() :Void;
	public function hover() :Void;
	public function press() :Void;
	public function release() :Void;
	public function releaseOutside() :Void;
	public function getActiveArea() :MovieClip;
}
