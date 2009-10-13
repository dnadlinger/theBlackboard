import at.klickverbot.core.CoreObject;

class at.klickverbot.ui.mouse.MouseoverArea extends CoreObject {
	/**
	 * Constructor.
	 */
	public function MouseoverArea( activeArea :MovieClip, overHandler :Function,
      outHandler :Function, boundingBoxOnly :Boolean ) {
      m_activeArea = activeArea;
      m_overHandler = overHandler;
      m_outHandler = outHandler;
      m_boundingBoxOnly = boundingBoxOnly;
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

	public function get boundingBoxOnly() :Boolean {
		return m_boundingBoxOnly;
	}
	public function set boundingBoxOnly( to :Boolean ) :Void {
		m_boundingBoxOnly = to;
	}

	private function getInstanceInfo() :Array {
	   return super.getInstanceInfo().concat( [ "activeArea: " + m_activeArea,
	     "boundingBoxOnly: " + m_boundingBoxOnly ] );
   }

   private var m_activeArea :MovieClip;
	private var m_currentlyOver :Boolean;
	private var m_overHandler :Function;
	private var m_outHandler :Function;
	private var m_boundingBoxOnly :Boolean;
}
