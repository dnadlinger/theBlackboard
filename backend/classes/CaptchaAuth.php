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
            'UPDATE captchaAuth SET solved = CURRENT_TIMESTAMP WHERE id = ?' );
         $statement->execute( array( $id ) );
      } else {
         $this->deleteStatement->execute( array( $id ) );
         throw new Exception( 'The captcha solution was not correct.',
            FaultCodes::INVALID_CAPTCHA_SOLUTION );
      }
   }

   public function isAuthenticated( $methodOwner, $methodName ) {
      // Solved captchas are only valid 300 seconds (5 minutes).
      $statement = $this->dbConn->getPdo()->prepare(
         'SELECT id FROM captchaAuth WHERE methodOwner = ? AND methodName = ? ' .
         'AND ( CURRENT_TIMESTAMP - solved ) < 300 LIMIT 1' );
      $statement->execute( array( $methodOwner, $methodName ) );

      $resultRows = $statement->fetchAll();
      if ( count( $resultRows ) < 1 ) {
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
      $result = strtolower( substr( base64_encode( md5( mt_rand() ) ), 0, 6 ) );
      $result = strtr( $result, 'o', '0' );
      return $result;
   }

   private $dbConn;
   private $deleteStatement;
}
?>