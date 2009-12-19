<?php
class Configuration {
   public function __construct ( DbConnector $dbConnector ) {
      $this->dbConn = $dbConnector;
      $this->configValues = array();
   }

   public function getByName( $keyName ) {
      if ( !isset( $this->configValues[ $keyName ] ) ) {
         try {
            $this->configValues[ $keyName ] = $this->loadValue( $keyName );
         } catch ( Exception $e ) {
            throw new ConfigKeyNotFoundException( $keyName );
         }
      }

      return $this->configValues[ $keyName ];
   }

   public function getAll() {
      $this->configValues = $this->loadAllValues();
      return $this->configValues;
   }

   private function loadValue( $keyName ) {
      // TODO: Cache this statement?
      $statement = $this->dbConn->getPdo()->prepare(
         'SELECT `value` FROM `configuration` WHERE `key` = ?' );
      $statement->execute( array( $keyName ) );

      $resultRows = $statement->fetchAll();

      if ( count( $resultRows ) < 1 ) {
         throw new Exception( 'Configuration key not found in the database: ' .
            $keyName );
      }

      $value = $resultRows[ 0 ][ 'value' ];
      return $value;
   }

   private function loadAllValues() {
      $statement = $this->dbConn->getPdo()->
         query( 'SELECT `key`, `value` FROM `configuration`' );

      $values = array();
      while ( $row = $statement->fetch() ) {
         $values[ $row[ 'key' ] ] = $row[ 'value' ];
      }

      return $values;
   }

   private $dbConn;
   private $configValues;
}
?>