<?php
class MethodUtils {
	public static function checkSignature( array $signature, array $params ) {
		if ( count( $signature ) !== count( $params ) ) {
			throw new InvalidSignatureException( implode( ', ', $signature ) );
		}

		for( $i = 0; $i < count( $signature ); ++$i ) {
			$currentParam = $params[ $i ];

			$valid = true;
			switch( $signature[ $i ] ) {
				case Types::INT:
					$valid = is_int( $params[ $i ] );
					break;
				case Types::DOUBLE:
					$valid = is_double( $params[ $i ] );
					break;
				case Types::BOOL:
					$valid = is_bool( $params[ $i ] );
					break;
				case Types::STRING:
					$valid = is_string( $params[ $i ] );
					break;
				// array and struct are both parsed into arrays.
				case Types::ARR:
				case Types::STRUCT:
					$valid = is_array( $params[ $i ] );
					break;
				default:
					throw new Exception( 'Invalid signature string.' );
					break;
			}
			if ( !$valid ) {
				throw new InvalidSignatureException( implode( ', ', $signature ) );
			}
		}
	}
}
?>