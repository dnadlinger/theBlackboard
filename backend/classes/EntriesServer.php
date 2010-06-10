<?php
class EntriesServer {
   public function __construct( Entries $wrappedEntries ) {
      $this->entries = $wrappedEntries;
   }

   public function getEntryCount( array $params ) {
      MethodUtils::checkSignature( array(), $params );
      return new ReturnValue( $this->entries->getEntryCount() );
   }

   public function getAllIds( array $params ) {
      MethodUtils::checkSignature( array( Types::STRING ), $params );
      return new ReturnValue( call_user_func_array(
         array( $this->entries, 'getAllIds' ), $params ) );
   }

   public function getIdsForRange( array $params ) {
      MethodUtils::checkSignature( array( Types::STRING, Types::INT, Types::INT ), $params );
      return new ReturnValue( call_user_func_array(
         array( $this->entries, 'getIdsForRange' ), $params ) );
   }

   public function getEntryById( array $params ) {
      MethodUtils::checkSignature( array( Types::INT ), $params );
      // TODO: Map return value to flat object here?
      return new ReturnValue( call_user_func_array(
         array( $this->entries, 'getEntryById' ), $params ) );
   }

   public function addEntry( array $params ) {
      MethodUtils::checkSignature( array( Types::STRING, Types::STRING, Types::STRING ), $params );
      return new ReturnValue( call_user_func_array(
         array( $this->entries, 'addEntry' ), $params ) );
   }

   private $entries;
}
?>