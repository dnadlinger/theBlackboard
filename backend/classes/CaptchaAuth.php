<?php
class CaptchaAuth {
   public function __construct( DbConnector $dbConnector ) {
      $this->dbConn = $dbConnector;
      $this->deleteStatement = $this->dbConn->getPdo()->prepare(
         'DELETE FROM captchaAuth WHERE id = ?' );
   }

   public function getCaptcha( $methodOwner, $methodName ) {
      $statement = $this->dbConn->getPdo()->prepare(
        'INSERT INTO captchaAuth ( methodOwner, methodName, solution ) ' .
        'VALUES ( :owner, :name, :solution )'
      );

      $statement->execute( array(
         'owner' => $methodOwner,
         'name' => $methodName,
         'solution' => $this->createCaptchaContent()
      ) );

      return $this->dbConn->getPdo()->lastInsertId();
   }

   public function solveCaptcha( $id, $solution ) {
      $statement = $this->dbConn->getPdo()->prepare(
         'SELECT solution FROM captchaAuth WHERE id = ? LIMIT 1' );
      $statement->execute( array( $id ) );

      $resultRows = $statement->fetchAll();
      if ( count( $resultRows ) < 1 ) {
         throw new Exception( 'A captcha with the specified id does not exist.' );
      }

      if ( $resultRows[ 0 ][ 'solution' ] == $solution ) {
         $statement = $this->dbConn->getPdo()->prepare(
            'UPDATE captchaAuth SET solved = 1 WHERE id = ?' );
         $statement->execute( array( $id ) );
      } else {
         $this->deleteStatement->execute( array( $id ) );
         throw new Exception( 'The captcha solution was not correct.' );
      }
   }

   public function isAuthenticated( $methodOwner, $methodName ) {
      $statement = $this->dbConn->getPdo()->prepare(
         'SELECT * FROM captchaAuth WHERE methodOwner = ? AND methodName = ? LIMIT 1' );
      $statement->execute( array( $methodOwner, $methodName ) );

      $resultRows = $statement->fetchAll();
      if ( count( $resultRows ) < 1 ) {
         return false;
      }

      $solved = $resultRows[ 0 ][ 'solved' ];
      if ( !$solved ) {
         return false;
      }

      $id = $resultRows[ 0 ][ 'id' ];
      $this->deleteStatement->execute( array( $id ) );

      return true;
   }

   public function getSolution( $id ) {
      $statement = $this->dbConn->getPdo()->prepare(
         'SELECT solution FROM captchaAuth WHERE id = ? LIMIT 1' );
      $statement->execute( array( $id ) );

      $resultRows = $statement->fetchAll();
      if ( count( $resultRows ) < 1 ) {
         throw new Exception( 'A captcha with the specified id does not exist.' );
      }

      return $resultRows[ 0 ][ 'solution' ];
   }

   private function createCaptchaContent() {
      // TODO: Make captcha length configurable?
      // Just a crappy attempt to create a suitable random string.
      return substr( base64_encode( md5( mt_rand() ) ), 0, 6 );
   }

   private $dbConn;
   private $deleteStatement;
}
?>