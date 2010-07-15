<?php
class Authenticator {
   public function __construct( DbConnector $dbConnector ) {
      $this->dbConn = $dbConnector;
      $this->authHandlers = array();
   }

   public function isAuthenticated( Request $request ) {
      $sets = $this->getAuthSetsForMethod( $request->getMethodOwner(),
         $request->getMethodName() );

      if ( empty( $sets ) ) {
         // If there are no authentication methods in the DB, the client does
         // not need to authenticate.
         return true;
      }

      $isAuthenticated = false;

      foreach ( $sets as $currentSet ) {
         $currentAuthenticated = true;
         foreach ( $currentSet as $method ) {
            $handler = $this->authHandlers[ $method ];
            if ( !( isset( $handler ) &&
               $handler->isAuthenticated( $request ) ) ) {
               $currentAuthenticated = false;
               break;
            }
         }

         if ( $currentAuthenticated ) {
            $isAuthenticated = true;
            break;
         }
      }

      return $isAuthenticated;
   }

   public function getAuthSetsForMethod( $methodOwner, $methodName ) {
      // TODO: Cache statement?
      $statement = $this->dbConn->getPdo()->prepare(
         'SELECT need_captcha FROM auth WHERE object = ? AND method = ?' );
      $statement->execute( array( $methodOwner, $methodName ) );

      $result = array();
      while( $row = $statement->fetch() ) {
         $currentSet = array();

         if ( $row[ 'need_captcha' ]  ) {
            $currentSet[] = AuthMethods::CAPTCHA;
         }

         $result[] = $currentSet;
      }

      return $result;
   }

   public function setMethodHandler( $method, IAuthHandler $authHandler ) {
      $this->authHandlers[ $method ] = $authHandler;
   }

   private $dbConn;
   private $authHandlers;
}
?>