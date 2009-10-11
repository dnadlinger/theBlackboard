import at.klickverbot.core.CoreObject;

/**
 * Enum-like class for the MovieClips that can be created by the theme system.
 * Only useful with an derrived class that provides access to some instances
 * (for example through public static members).
 *
 * Alternatively we could also use plain strings in the theme system, but then
 * type safety would not be guaranteed and we would not have a central place
 * where all needed clips are recorded.
 *
 */
class at.klickverbot.theme.ClipId extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function ClipId( id :String ) {
      m_id = id;
   }

   /**
    * Returns the ClipId as a string.
    */
   public function getId() :String {
      return m_id;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( m_id );
   }

   private var m_id :String;
}