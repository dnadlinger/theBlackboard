/**
 * Application-specific backend server codes.
 *
 * Required to be consistend across all backens which throw a specific fault.
 */
class at.klickverbot.theBlackboard.service.BackendFaultCodes {
   public static var AUTHENTICATION_NEEDED :Number = 1;
   public static var INVALID_CAPTCHA_SOLUTION :Number = 2;
}
