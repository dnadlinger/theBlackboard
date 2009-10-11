<?php
class DbConnector {
	public function __construct( $dsn, $username, $password ) {
		$this->dsn = $dsn;
		$this->username = $username;
		$this->password = $password;

		$this->pdo = null;
	}

	public function getPdo() {
		if ( $this->pdo == null ) {
			$this->connect();
		}
		return $this->pdo;
	}

	private function connect() {
		try {
			$this->pdo = new PDO(
				$this->dsn,
				$this->username,
				$this->password,
				array( PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION )
			);
		} catch ( PDOException $e ) {
			// We don't want to leak any interesting details, let's be concise.
			throw new Exception( 'Error while connecting to database server ' .
				$this->dsn );
		}
	}


	private $dsn;
	private $username;
	private $password;

	private $pdo;
}
?>