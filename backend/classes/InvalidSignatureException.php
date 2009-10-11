<?php
class InvalidSignatureException extends Exception {
	public function __construct( $correctSignature ) {
		parent::__construct( 'Method called with illegal parameter types. ' .
			'Correct signature is (' . $correctSignature . ').' );
		$this->correctSignature = $correctSignature;
	}

	public function getCorrectSignature() {
		return $this->correctSignature;
	}

	private $correctSignature;
}
?>