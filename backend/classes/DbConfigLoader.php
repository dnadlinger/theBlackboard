<?php
class DbConfigLoader {
	public function makeConnectorFromFile( $fileName ) {
		if ( StringUtils::isEmpty( $fileName ) ) {
			throw new Exception( 'Invalid db config file name: ' . $fileName );
		}

		@include( $fileName );

		if ( StringUtils::isEmpty( $configDbDsn ) ||
			StringUtils::isEmpty( $configDbUsername ) ||
			StringUtils::isEmpty( $configDbPassword ) ) {

			throw new Exception( 'Invalid db config file: ' . $fileName . "\n" .
				'Remember that empty db passwords are not allowed!' );
		}

		return new DbConnector( $configDbDsn, $configDbUsername, $configDbPassword );
	}
}
?>