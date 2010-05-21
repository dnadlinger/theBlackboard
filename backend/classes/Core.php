<?php
class Core {
   public function __construct( $rootPath ) {
      $this->initAutoloader( $rootPath );
      $this->initDatabase();
      $this->initController();
      date_default_timezone_set( Constants::TIMEZONE );
   }

   public function getFrontController() {
      return $this->frontController;
   }

   private function initAutoloader( $rootPath ) {
      // It is ugly to include the classes here inside the function, but
      // otherwise we would have to use another hardcoded path.
      require_once( $rootPath. DIRECTORY_SEPARATOR . Constants::CLASSES_DIR .
         DIRECTORY_SEPARATOR . 'PathBuilder.php' );
      $pathBuilder = PathBuilder::getInstance();
      $pathBuilder->setRootPath( $rootPath );

      require_once( $pathBuilder->buildAbsolutePath( Constants::CLASSES_DIR,
         'Autoloader.php' ) );
      Autoloader::init();
   }

   private function initDatabase() {
      $configFilePath = PathBuilder::getInstance()->buildAbsolutePath(
            Constants::CONFIG_DIR, Constants::CONFIG_FILE_DB );
      $configLoader = new DbConfigLoader();

      try {
         $this->dbConnector = $configLoader->makeConnectorFromFile( $configFilePath );
      } catch ( Exception $e ) {
         throw new Exception( 'Error while loading database configuration: ' .
            $e->getMessage() );
      }
   }

   private function initController() {
      $this->frontController = new FrontController();

      // Create the database interface objects and their proxies and register
      // them with the FrontController.
      $configuration = new Configuration( $this->dbConnector );
      $entries = new Entries( $this->dbConnector );
      $authenticator = new Authenticator( $this->dbConnector );
      $captchaAuth = new CaptchaAuth( $this->dbConnector );

      $authenticator->setMethodHandler( AuthMethods::CAPTCHA,
         new CaptchaAuthHandler( $captchaAuth ) );

      $services = array(
         'configuration' => new ConfigurationServer( $configuration ),
         'entries' => new EntriesServer( $entries ),
         'auth' => new AuthServer( $authenticator ),
         'captchaAuth' => new CaptchaAuthServer( $captchaAuth )
      );

      foreach( $services as $name => $server ) {
         $this->frontController->addResolver( new AuthResolverProxy(
            new ClassResolver( $name, $server ), $authenticator ) );
      }

      $this->frontController->addResolver(
         new CaptchaImageResolver( $captchaAuth ) );
   }

   private $dbConnector;
   private $frontController;
}
?>