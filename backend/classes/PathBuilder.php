<?php
class PathBuilder {
	private function __construct() {
		$this->rootPath = '.';
		$this->seperator = DIRECTORY_SEPARATOR;
	}
	private function __clone() {
	}

	public static function getInstance() {
		if ( self::$instance == null ) {
			self::$instance = new PathBuilder();
		}
		return self::$instance;
	}

	public function toAbsolute( $relativePath ) {
		return $this->buildPath( $this->rootPath, $relativePath );
	}

	public function buildPath( /* any number of strings */ ) {
		$path = $this->buildPathFromArray( func_get_args() );
		return $path;
	}

	public function buildAbsolutePath( /* any number of strings */ ) {
		$path = $this->rootPath;
		$path .= $this->seperator;
		$path .= $this->buildPathFromArray( func_get_args() );
		return $path;
	}

	public function getRootPath() {
		return $this->rootPath;
	}
	public function setRootPath( $projectRootPath ) {
		$this->rootPath = $projectRootPath;
	}

	public function getSeperator() {
		return $this->rootPath;
	}
	public function setSeperator( $directorySeperator ) {
		$this->seperator = $directorySeperator;
	}

	private function buildPathFromArray( array $pathElements ) {
		$numElements = count( $pathElements );
		if ( $numElements === 0 ) {
			return '';
		}

		$path = $pathElements[ 0 ];
		for ( $i = 1; $i < $numElements; ++$i ) {
			$path .= $this->seperator;
			$path .= $pathElements[ $i ];
		}

		return $path;
	}

	private static $instance = null;

	private $rootPath;
	private $seperator;
}
?>