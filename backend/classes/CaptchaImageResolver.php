<?php
class CaptchaImageResolver implements IMethodResolver {
   public function __construct( CaptchaAuth $target ) {
      $this->target = $target;
   }

   public function canResolve( Request $request ) {
      return ( $request instanceof CaptchaImageRequest );
   }

   public function resolve( Request $request, Response $response ) {
      if ( !$this->canResolve( $request ) ) {
         throw new MethodNotFoundException( $request->getMethodOwner() . '.' .
            $request->getMethodName() );
      }

      $solution = $this->target->getSolution( $request->getMethodParams() );
      $response->setReturnValue( new ReturnValue( $solution, Types::STRING ) );
   }

   private $target;
}
?>