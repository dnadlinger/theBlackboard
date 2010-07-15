<?php
class AuthResolverProxy implements IMethodResolver {
   public function __construct( IMethodResolver $resolver, Authenticator $authenticator ) {
      $this->resolver = $resolver;
      $this->authenticator = $authenticator;
   }

   public function canResolve( Request $request ) {
      return $this->resolver->canResolve( $request );
   }

   public function resolve( Request $request, Response $response ) {
      if ( !$this->authenticator->isAuthenticated( $request ) ) {
         $response->setFault( FaultCodes::AUTHENTICATION_NEEDED,
            'Authentication needed to call this method.' );
         return;
      }

      $this->resolver->resolve( $request, $response );
   }

   private $resolver;
   private $authenticator;
}
?>