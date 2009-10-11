<?php
class StringUtils {
	public static function isEmpty( $testString ) {
		if ( ( !is_string( $testString ) ) || ( $testString === '' ) ) {
			return true;
		}
		return false;
	}
}
?>