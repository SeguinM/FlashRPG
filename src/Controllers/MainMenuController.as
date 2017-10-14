package src.Controllers
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  MainMenuController extends MovieClip
	{
		
		// VARIABLES------------------------------------------------------------
		public var buttonClickedCallback:Function;	// Called when button is clicked
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function MainMenuController():void
		{
			init();
		} // end of function MainMenuController
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			initButtons();
		} // end of function init
		
		private function initButtons():void
		{
			var newGameButton:MovieClip = getChildByName("btn_newGame") as MovieClip;
			
			if (newGameButton == null) return;
			
			newGameButton.addEventListener(MouseEvent.CLICK, onNewGameClicked);
		} // end of function initButtons
		
		private function onNewGameClicked(event:MouseEvent):void
		{
			if (buttonClickedCallback != null)
				buttonClickedCallback(event.target.name);
		} // end of function onNewGameClicked
		
	} // end of class MainMenuController
	
} // enDate of package src.Controllers