<?php
class ClassResolver implements IMethodResolver {
	public function __construct( $objectName, $targetObject ) {
		$this->name = $objectName;
		$this->target = $targetObject;
	}

	public function canResolve( Request $request ) {
		return ( ( $request->getMethodOwner() === $this->name ) &&
			( is_callable( array( $this->target, $request->getMethodName() ) ) ) );
	}

	public function resolve( Request $request, Response $response ) {
		if ( !$this->canResolve( $request ) ) {
			throw new MethodNotFoundException( $request->getMethodOwner() . '.' .
				$request->getMethodName() );
		}

		$methodName = $request->getMethodName();
		try {
			$result = $this->target->$methodName( $request->getMethodParams() );

			if ( $result != null ) {
				$response->setReturnValue( $result );
			}
		} catch( InvalidSignatureException $e ) {
			$response->setFault( FaultCodes::INVALID_METHOD_PARAMS, $e->getMessage() );
		} catch( InvalidParameterException $e ) {
			$response->setFault( FaultCodes::INVALID_METHOD_PARAMS, $e->getMessage() );
		}
	}

	private $name;
	private $target;
}
?>