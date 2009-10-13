import at.klickverbot.core.CoreObject;

class at.klickverbot.ui.mouse.MouseoverArea extends CoreObject {
	/**
	 * Constructor.
	 */
	public function MouseoverArea( activeArea :MovieClip, overHandler :Function,
      outHandler :Function ) {
      m_activeArea = activeArea;
      m_overHandler = overHandler;
      m_outHandler = outHandler;
   }

   public function get activeArea() :MovieClip {
		return m_activeArea;
	}
	public function set activeArea( to :MovieClip ) :Void {
		m_activeArea = to;
	}

	public function get currentlyOver() :Boolean {
		return m_currentlyOver;
	}
	public function set currentlyOver( to :Boolean ) :Void {
		m_currentlyOver = to;
	}

	public function get overHandler() :Function {
		return m_overHandler;
	}
	public function set overHandler( to :Function ) :Void {
		m_overHandler = to;
	}

	public function get outHandler() :Function {
		return m_outHandler;
	}
	public function set outHandler( to :Function ) :Void {
		m_outHandler = to;
	}


	private var m_activeArea :MovieClip;
	private var m_currentlyOver :Boolean;
	private var m_overHandler :Function;
	private var m_outHandler :Function;
}
