<?php
class ConfigurationServer {
	public function __construct( Configuration $wrappedConfiguration ) {
		$this->configuration = $wrappedConfiguration;
	}

	public function getByName( array $params ) {
		MethodUtils::checkSignature( array( 'string' ), $params );
		return new ReturnValue( $this->configuration->getByName( $params[ 0 ] ) );
	}

	public function getAll( array $params ) {
		MethodUtils::checkSignature( array(), $params );
		return new ReturnValue( $this->configuration->getAll() );
	}

	private $configuration;
}
?>