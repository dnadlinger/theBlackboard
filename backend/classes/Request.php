<?php
abstract class Request {
	public final function __construct() {
		$this->methodOwner = null;
		$this->methodName = null;
		$this->methodParams = null;

		$this->init();
	}

	public function isValid() {
		return !( StringUtils::isEmpty( $this->methodOwner ) ||
			StringUtils::isEmpty( $this->methodName ) );
	}

	public function getMethodOwner() {
		return $this->methodOwner;
	}
	public function getMethodName() {
		return $this->methodName;
	}
	public function getMethodParams() {
		return $this->methodParams;
	}

	abstract protected function init();

	protected $methodOwner;
	protected $methodName;
	protected $methodParams;
}
?>