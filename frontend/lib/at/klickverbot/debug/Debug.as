import at.klickverbot.debug.DebugLevel;
import at.klickverbot.debug.Log;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.debug.Logger;

/**
 * Main debug class.
 * Provides helper functions for debbuging such as assert.
 *
 */
class at.klickverbot.debug.Debug {
   /**
    * If the given condition is true, the given error message is traced.
    *
    * It simplifies creating developing time safety checks.
    * Note that, unlike the standard assert in most programming languages,
    * this function doesn't abort the program.
    *
    * @param condition The condition that should be true.
    * @param failMessage A string containing the message that is displayed if
    *        the condition is false.
    */
   public static function assert( condition :Boolean, failMessage :String ) :Void {
      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }

      if ( !condition ) {
         LIBRARY_LOG.log( LogLevel.FATAL, "Assertion failed: " + failMessage );
         // throw new Error( "Assert failed: " + failMessage );
      }
   }

   public static function assertFalse( condition :Boolean, failMessage :String ) :Void {
      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }

      assert( !condition, failMessage );
   }

   public static function assertEqual( first :Object, second :Object,
      failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assert( first === second, failMessage );
   }

   public static function assertNotEqual( first :Object, second :Object,
      failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assert( first !== second, failMessage );
   }

   public static function assertNull( target :Object, failMessage :String ) :Void {
      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assert( target == null, failMessage );
   }

   public static function assertNotNull( target :Object, failMessage :String ) :Void {
      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assert( target != null, failMessage );
   }

   public static function assertNumber( target :Object, failMessage :String ) :Void {
      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assert( !isNaN( Number( target ) ), failMessage );
   }

   public static function assertPositive( target :Number, failMessage :String ) :Void {
      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assertNumber( target, failMessage );
      assert( target >= 0, failMessage );
   }

   public static function assertInRange( lowerLimit :Number, target :Number,
      upperLimit :Number, failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assertNumber( target, failMessage );
      assert( ( lowerLimit <= target ) && ( target <= upperLimit ), failMessage );
   }

   public static function assertLess( first :Number, second :Number,
      failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assertNumber( first, failMessage );
      assertNumber( second, failMessage );
      assert( first < second, failMessage );
   }

   public static function assertLessOrEqual( first :Number, second :Number,
      failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assertNumber( first, failMessage );
      assertNumber( second, failMessage );
      assert( first <= second, failMessage );
   }

   public static function assertIncludes( haystack :Array, needle :Object,
      failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }

      var found :Boolean = false;
      for ( var i :Number = 0; i < haystack.length; ++i ) {
         if ( haystack[ i ] === needle ) {
            found = true;
            break;
         }
      }

      assert( found, failMessage );
   }

   public static function assertExcludes( haystack :Array, needle :Object,
      failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }

      var found :Boolean = false;
      for ( var i :Number = 0; i < haystack.length; ++i ) {
         // TODO: This probably does not work as intended when checking for null/undefined elements because !( null === undefined ).
         if ( haystack[ i ] === needle ) {
            found = true;
            break;
         }
      }

      assertFalse( found, failMessage );
   }

   public static function assertInstanceOf( value :Object, klass :Function,
      failMessage :String ) :Void {

      if ( LEVEL == DebugLevel.NONE ) {
         return;
      }
      assert( value instanceof klass, failMessage );
   }

   /**
    * Handles a call to the specified pure virtual function.
    *
    * Convinience method for centraliced handling of pure virtual function
    * calls (a function which is not implemented in an abstract base class).
    * In other languages these forbidden calls generate a runtime error, but in
    * ActionScript 2, the whole concept of abstract classes and thus functions
    * lacking implementation does not exist.
    *
    * @param functionName The full name of the function, including the class.
    */
   public static function pureVirtualFunctionCall( functionName :String ) :Void {
      LIBRARY_LOG.error( "Pure virtual function called: " + functionName );
   }

   /**
    * If the Fully Qualified Identifier shall be used in debug messages
    * (e.g. at.klickverbot.debug.Debug). If not, only the class name is used.
    * For example, this value should be interpreted in the toString()-functions.
    */
   public static var FQI :Boolean = false;

   /**
    * The active debug level.
    * Defaults to DebugLevel.NORMAL, but overwriting the constant at the very
    * beginning of the program execution may be suitable.
    */
   public static var LEVEL :DebugLevel = DebugLevel.NORMAL;

   /**
    * Central log for the at.klickverbot - codebase itself. Usually there
    * should be no messages logged, but attaching a listener is adviceable
    * to hunt bugs.
    */
   public static var LIBRARY_LOG :Log = Logger.getLog( "klickverbot" );
}
