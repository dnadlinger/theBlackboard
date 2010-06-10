<?php
class Entries {
   public function __construct( DbConnector $dbConnector ) {
      $this->dbConn = $dbConnector;
      $this->entryCount = null;
   }

   public function getEntryCount( $forceUpdate = false ) {
      if ( ( $this->entryCount == null ) || $forceUpdate ) {
         $queryResult = $this->dbConn->getPdo()->query( 'SELECT COUNT(*) FROM entries' );
         $this->entryCount = $queryResult->fetchColumn();
      }
      return $this->entryCount;
   }

   public function getAllIds( $sortingType ) {
      $querySql = 'SELECT id FROM entries ORDER BY ' .
         $this->getSqlForSortingType( $sortingType );

      $queryResult = $this->dbConn->getPdo()->query( $querySql );

      $resultIds = array();
      while( $row = $queryResult->fetch() ) {
         $resultIds[] = (int)$row[ 'id' ];
      }

      return $resultIds;
   }

   public function getIdsForRange( $sortingType, $startIndex, $entryCount ) {
      $querySql = 'SELECT id FROM entries ORDER BY ' .
         $this->getSqlForSortingType( $sortingType );

      // This explicit checks for validity and not for wrong values should,
      // in conjunction with the type checks, make injection attacks impossible.
      if ( !( ( 0 <= $startIndex ) &&
         ( ( $startIndex + $entryCount ) <= $this->getEntryCount() ) ) ) {
         throw new RangeException( 'Invalid range specified: ' .
            $startIndex . ', ' . $entryCount );
      }

      if ( $entryCount <= 0 ) {
         throw new RangeException( 'Invalid range specified: ' .
            'There must be at least one entry selected.' );
      }

      $querySql .= ' LIMIT ' . $startIndex . ', ' . $entryCount;

      $queryResult = $this->dbConn->getPdo()->query( $querySql );

      $resultIds = array();
      while( $row = $queryResult->fetch() ) {
         $resultIds[] = (int)$row[ 'id' ];
      }

      return $resultIds;
   }

   public function getEntryById( $entryId ) {
      // TODO: Cache statement?
      $statement = $this->dbConn->getPdo()->prepare(
         'SELECT * FROM entries WHERE id = ? LIMIT 1' );
      $statement->execute( array( $entryId ) );

      $resultRows = $statement->fetchAll();
      if ( count( $resultRows ) < 1 ) {
         throw new Exception( 'An entry with the specified id does not exist' );
      }

      $rawEntry = $resultRows[ 0 ];

      // TODO: Use nicer AA syntax.
      $entry = array();
      $entry[ 'id' ] = $rawEntry[ 'id' ];
      $entry[ 'caption' ] = $rawEntry[ 'caption' ];
      $entry[ 'author' ] = $rawEntry[ 'author' ];
      $entry[ 'drawingString' ] = $rawEntry[ 'drawingString' ];
      // TODO: Convert this in the mysql query.
      $entry[ 'timestamp' ] = strtotime( $rawEntry[ 'timestamp' ] );

      return $entry;
   }

   public function addEntry( $caption, $author, $drawingString ) {
      // TODO: Accept Entry object as parameter?
      // TODO: Validity checks here or in the server?
      if ( StringUtils::isEmpty( $caption ) ) {
         throw new InvalidParameterException( "caption must not be empty." );
      }
      if ( StringUtils::isEmpty( $author ) ) {
         throw new InvalidParameterException( "author must not be empty." );
      }
      if ( StringUtils::isEmpty( $drawingString ) ) {
         throw new InvalidParameterException( "drawingString must not be empty." );
      }

      // TODO: Cache statement?
      $statement = $this->dbConn->getPdo()->prepare(
         'INSERT INTO entries ( id, caption, author, drawingString, timestamp ) VALUES ( NULL, :caption, :author, :drawingString, CURRENT_TIMESTAMP );' );
      $statement->execute(	array( ':caption' => $caption, ':author' => $author,
         ':drawingString' => $drawingString ) );

      return $this->dbConn->getPdo()->lastInsertId();
   }

   private function getSqlForSortingType( $type ) {
      if ( $type == 'oldToNew' ) {
         return 'timestamp ASC';
      } elseif ( $type == 'newToOld' ) {
         return 'timestamp DESC';
      } else {
         throw new InvalidArgumentException( 'Unknown sorting type: ' . $type );
      }
   }

   private $dbConn;
   private $entryCount;
}
?>