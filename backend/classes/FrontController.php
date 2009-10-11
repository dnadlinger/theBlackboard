<?php
class FrontController {
	public function __construct() {
		$this->methodResolvers = array();
	}

	public function addResolver( IMethodResolver $methodResolver ) {
		$this->removeResolver( $methodResolver );
		$this->methodResolvers[] = $methodResolver;
	}

	public function removeResolver( IMethodResolver $methodResolver ) {
		$resolverKey = array_search( $methodResolver, $this->methodResolvers, true );
		if( $resolverKey === false ) {
			return false;
		}
		// TODO: array_slice needs an index instead of a key?
		array_slice( $this->methodResolvers, $resolverKey );
		return true;
	}

	public function handleRequest( IProtocol $protocol ) {
		// 'Hacks' for catching the php errors and unhandled exceptions, we try to
		// return them as a protocol-specific fault response.
		$this->currentProtocol = $protocol;

		set_error_handler( array( $this, 'errorHandler' ) );
		ini_set( 'display_errors', 'Off' );
		set_exception_handler( array( $this, 'uncaughtExceptionHandler' ) );
		// End of the hacks.

		$request = $protocol->createRequest();
		$response = $protocol->createResponse();

		if ( $request->isValid() ) {
			$methodFound = false;
			foreach ( $this->methodResolvers as $currentResolver ) {
				if( $currentResolver->canResolve( $request ) ) {
					$methodFound = true;
					$currentResolver->resolve( $request, $response );
					break;
				}
			}

			if ( !$methodFound ) {
				$response->setFault( FaultCodes::METHOD_NOT_FOUND,
					'Method ' .	$request->getMethodOwner() . '.' .
					$request->getMethodName() . ' not found.' );
			}
		} else {
			$response->setFault( FaultCodes::INVALID_REQUEST,
				'Invalid method call.' );
		}

		$response->writeOutput();
	}

	public function uncaughtExceptionHandler( Exception $e ) {
		if ( $e->getCode() != 0 ) {
			$this->dieWithFaultResponse( $e->getCode(), $e->getMessage() );
		} else {
			$this->handleInternalError( $e->getMessage(), $e->getFile(), $e->getLine() );
		}
	}

	public function errorHandler( $code, $string, $file, $line ) {
		if ( !error_reporting() ) {
			return;
		}
		$this->handleInternalError( $string, $file, $line );
	}

	private function handleInternalError( $string, $file, $line ) {
		$this->dieWithFaultResponse( FaultCodes::INTERNAL_ERROR,
			'Internal error occured: ' . $string . ' (at ' . basename( $file ) . ':' . $line .').' );
	}

	private function dieWithFaultResponse( $code, $message ) {
		$response = $this->currentProtocol->createResponse();
		$response->setFault( $code, $message );
		$response->writeOutput();
		die();
	}

	private $methodResolvers;
	private $currentProtocol;
}
?>