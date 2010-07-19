<?php
class DirectClassResolver implements IMethodResolver {
   public function __construct( $objectName, $targetObject, $methodInfo ) {
      $this->name = $objectName;
      $this->target = $targetObject;
      $this->methodInfo = $methodInfo;
   }

   public function canResolve( Request $request ) {
      return ( ( $request->getMethodOwner() === $this->name ) &&
         isset( $this->methodInfo[ $request->getMethodName() ] ) );
   }

   public function resolve( Request $request, Response $response ) {
      if ( !$this->canResolve( $request ) ) {
         throw new MethodNotFoundException( $request->getMethodOwner() . '.' .
            $request->getMethodName() );
      }

      $methodName = $request->getMethodName();
      $params = $request->getMethodParams();

      try {
         MethodUtils::checkSignature( $this->methodInfo[ $methodName ], $params );
         $result = call_user_func_array( array( $this->target, $methodName ), $params );

         if ( $result != null ) {
            $response->setReturnValue( new ReturnValue( $result ) );
         }
      } catch( InvalidSignatureException $e ) {
         $response->setFault( FaultCodes::INVALID_METHOD_PARAMS, $e->getMessage() );
      } catch( InvalidParameterException $e ) {
         $response->setFault( FaultCodes::INVALID_METHOD_PARAMS, $e->getMessage() );
      }
   }

   private $name;
   private $target;
   private $methodInfo;
}
?>