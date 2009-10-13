/**
 * Provides a method for creating delegate functions, wrapper functions to
 * execute a specified function in a certain context (as if it was a member of
 * the specified object). They are needed in ActionScript 2 because Function
 * objects are not tied to a (class) context – they loose their original context
 * when they are passed on.
 *
 * The mx.utils.Delegate class cannot be used with MTASC because it messes
 * a bit with the variable scopes.
 */
class at.klickverbot.util.Delegate {
   /**
    * Returns a delegate function which executes the specified function in the
    * specified context.
    *
    * Note that unlike the "original" delegate, this function does not provide
    * support for additional arguments passed to the wrapped function. This is a
    * deliberate choice to prevent the use of a Delegate where another solution
    * would fit much better.
    *
    * @param targetContext The context in which the function is executed.
    * @param wrappedFunction The function that is tied to the context.
    * @return The delegate (function).
    */
   public static function create( targetContext :Object,
      wrappedFunction :Function ) :Function {

      var wrapper :Function = function() :Object {
         var thisFunction :Function = arguments.callee;
         return thisFunction[ "wrappedFunction" ].apply(
            thisFunction[ "targetContext" ], arguments );
      };

      wrapper[ "targetContext" ] = targetContext;
      wrapper[ "wrappedFunction" ] = wrappedFunction;

      return wrapper;
   }
}
