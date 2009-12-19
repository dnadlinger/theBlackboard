<?php
interface IMethodResolver {
   public function canResolve( Request $request );
   public function resolve( Request $request, Response $response );
}
?>