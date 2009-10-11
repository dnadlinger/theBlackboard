import at.klickverbot.core.CoreObject;
import at.klickverbot.cairngorm.commands.ICommand;
import at.klickverbot.cairngorm.control.CairngormEvent;
import at.klickverbot.cairngorm.control.CairngormEventDispatcher;
import at.klickverbot.debug.LogLevel;
import at.klickverbot.debug.Logger;

class at.klickverbot.cairngorm.control.FrontController extends CoreObject {
   public function FrontController() {
      m_registeredCommands = new Object();
   }

   public function addCommand( commandName :String, commandClass :Function ) :Void {
      if ( m_registeredCommands[ commandName ] != null ) {
         Logger.getLog( "Controller" ).log( LogLevel.WARN,
            "Command name already registered: " + commandName );
         return;
      }
      m_registeredCommands[ commandName ] = commandClass;
      CairngormEventDispatcher.getInstance().addEventListener( commandName,
         this, handleEvent );
   }

   public function removeCommand( commandName :String ) :Boolean {
      if ( m_registeredCommands[ commandName ] == null ) {
         return false;
      }
      delete m_registeredCommands[ commandName ];
   }

   private function handleEvent( event :CairngormEvent ) :Void {
      var commandClass :Function = m_registeredCommands[ event.type ];

      var command :ICommand = new commandClass();
      command.execute( event );
   }

   private var m_registeredCommands :Object;
}
