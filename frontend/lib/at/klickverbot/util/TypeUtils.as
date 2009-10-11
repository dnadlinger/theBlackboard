/**
 * Provides a way to get
 * Adapted from Simon Wacker's great work for the as2lib framework.
 *
 */
class at.klickverbot.util.TypeUtils {
   /**
    * Returns the type name of the passed object.
    *
    * @param target The object to get the type name of.
    * @param fullyQualified If the name should include the package name.
    *        Defaults to false.
    * @return A string containing the type name.
    */
   public static function getTypeName( target :Object, fullyQualified :Boolean ) :String {
      if ( fullyQualified == null ) {
         fullyQualified = false;
      }

      if ( target == null ) {
         return null;
      }

      // According to Simon Wacker, __constructor__ and constructor are likely
      // to be incorrect on dynamic instances. We thus use __proto__ which
      // refers to the prototype of the type.
      var targetPrototype :Object;
      if ( typeof( target ) == "function" ) {
         targetPrototype = target.prototype;
      } else {
         targetPrototype = target.__proto__;
      }

      var name :String = readNameFromCache( targetPrototype );
      if ( name == null ) {
         // Unhide the objects in _global.
         setPropFlags( _global, null, 0, 1 );

         // Start the recursive search.
         name = searchPrototypeInPackage( targetPrototype, _global, "", [ _global ] );
      }

      if ( !fullyQualified ) {
         name = String( name.split( "." ).pop() );
      }

      return name;
   }

   /**
    * "Workhorse" function for recursively searching the package tree for the
    * target prototype and thus constructing its fully qualified name.
    *
    * @param targetPrototype The prototype we are looking for.
    * @param package The package we are searching in.
    * @param packagePath The path (string) of this package.
    * @param searchedPackages Keeps track of the already searched packages to
    *        avoid endless recursion.
    */
   private static function searchPrototypeInPackage( targetPrototype :Object,
      package :Object, packagePath :String, visitedPackages :Array ) :String {

      // Iterate through all members of the current package, that is classes and
      // sub-packages.
      for ( var currentKey :String in package ) {
         try {
            var currentChild :Object = package[ currentKey ];

            // Is this the prototype we are searching for?
            // We have to check for strict equality because not doing so would
            // result in a wrong result when searching for prototype of a
            // Boolean or Number.
            if ( !isGlobalDuplicate( currentKey ) &&
               ( currentChild.prototype === targetPrototype ) ) {

               // Construct the full name of the type.
               var resultName :String = packagePath + currentKey;

               // Save the name for caching purposes.
               writeNameToCache( currentChild, resultName );

               return resultName;
            }

            // If not, check if the current child is a package or if it is a
            // class – typeof( SomeClass ) == "function".
            if ( typeof( currentChild ) == "object" ) {
               // TODO: currentChild.__constructor__.valueOf()?!?

               // If it is a package, continue by recursively seraching its
               // children.

               // Check if we have already been here to avoid endless recursion
               // in case of circular references.
               var alreadySearched :Boolean = false;
               for ( var i:Number = 0; i < visitedPackages.length; i++ ) {
                  // TODO: Why valueOf here?
                  if ( visitedPackages[ i ].valueOf() == currentChild.valueOf() ) {
                     alreadySearched = true;
                     break;
                  }
               }

               // If not, start the search in the child and return the result if
               // the prototype was found.
               if ( !alreadySearched ) {
                  visitedPackages.push( currentChild );

                  var resultFromCurrentChild :String = searchPrototypeInPackage(
                     targetPrototype, currentChild,
                     packagePath + currentKey + ".", visitedPackages );

                  if ( resultFromCurrentChild != null ) {
                     return resultFromCurrentChild;
                  }
               }
            } else if ( typeof( currentChild ) == "function" ) {
               // If it is a class, cache its name while we are at it.
               writeNameToCache( currentChild, packagePath + currentKey );
            }
         } catch ( e :Object ) {
            // Ignore any exceptions that might occur due to our dirty hacking.
         }
      }

      // The prototype was not found in this package and any of its descendants.
      return null;
   }

   /**
    * The Flex compiler stores every class twice: once in _global (the points in
    * the fully qualified name are replaced with underscores to get a valid
    * property name) and once in its actual package (which is an object that
    * resides under _global).
    * We have to ignore the references in _global in our search.
    */
   private static function isGlobalDuplicate( propertyName :String ) :Boolean {
      var hasUnderscore :Boolean = ( propertyName.indexOf("_") >= 0 );
      var realName :String = propertyName.split( "_" ).join( "." );
      var realClassExists :Boolean = ( eval( "_global." + realName ) != null );
      return( hasUnderscore && realClassExists );
   }

   /**
    * Retrives the name of the prototype from the cache.
    * Returns null if it has not already been cached.
    */
   private static function readNameFromCache( protoType :Object ) :String {
      var cachedName :String = protoType[ NAME_CACHE_PROPERTY ];

      // The name has not already been cached.
      if ( cachedName == null ) {
         return null;
      }

      // TODO: What is this good for?
      if ( cachedName == protoType.__proto__[ NAME_CACHE_PROPERTY ] ) {
         return null;
      }

      return cachedName;
   }

   /**
    * Writes the specified name for the specified class to the cache.
    */
   private static function writeNameToCache( targetType :Object, name :String ) :Void {
      targetType.prototype[ NAME_CACHE_PROPERTY ] = name;
      setPropFlags( targetType.prototype, NAME_CACHE_PROPERTY, 1, 1 );
   }

   /**
    * @see http://labs.blitzagency.com/?p=41
    */
   private static function setPropFlags( targetObject :Object,
      propertyList :String, bitFlag :Number, clearBitFlag :Number ) :Void {
       _global[ "ASSetPropFlags" ]( targetObject, propertyList, bitFlag, clearBitFlag );
   }

   private static var NAME_CACHE_PROPERTY :String = "__at_klickverbot__TYPE_NAME";
}
