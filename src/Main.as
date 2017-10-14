package src {
	
	// Main project file for game
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import src.Controllers.CharacterDataManager;
	import src.Controllers.CombatController;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import src.Controllers.LevelController;
	import src.Controllers.LightingController;
	import src.Controllers.MainMenuController;
	import src.Controllers.PartyController;
	import src.Controllers.PlayerController;
	import src.Controllers.UIControllerBase;
	import src.Controllers.WorldController;
	import src.Entities.Character;
	import src.Entities.Weapon;
	import src.Events.EventWithData;
	import src.Utilities.LevelLoader;
	import src.Utilities.SpriteSwapper;
	import src.Utilities.XMLLoader;
	
	
	public class Main extends MovieClip 
	{
		
		// STATIC CONSTS:
		private static const DEBUG:Boolean = true;
		private static const EVENT_LOADING_COMPLETE:String = "onAllSWFsComplete";
		private static const EVENT_LOADING_FAIL:String = "onLoadFailEvent";
		
		// CONTROLLERS:
		private var combatController:CombatController;
		private var levelController:LevelController;
		private var lightingController:LightingController;
		private var characterDataManager:CharacterDataManager;
		private var playerController:PlayerController;
		private var worldController:WorldController;
		private var partyController:PartyController;
		private var uiController:UIControllerBase;
		
		private var controllers:Array = [];    // array of all the controllers
		
		// instance of Main
		public static var instance:Main;
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		public function Main() 
		{
			super();
			init();
		} // end of constructor function
	
	
	
	
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			
			// creates instance of file
			instance = this;
			initControllers();                // Controllers for various engines and routines
			initExternals();                  // Loads external assets
			
			if (DEBUG == true)
				debug();
		} // end of function init
		
		private function initControllers():void
		{	
			combatController = new CombatController(stage, combatContainer, world);
			levelController = new LevelController(stage);
			lightingController = new LightingController(stage);
			characterDataManager = new CharacterDataManager();
			playerController = new PlayerController(stage, world);
			worldController = new WorldController(stage, world, combatContainer);
			partyController = new PartyController(stage);
			uiController = new UIControllerBase(UI);
		
			worldController.playerController = playerController;
			worldController.partyController = partyController;
			characterDataManager.partyController = partyController;
			characterDataManager.uiController = uiController;
			partyController.characterDataManager = characterDataManager;
			playerController.worldController = worldController;
			playerController.uiController = uiController;
			combatController.partyController = partyController;
			combatController.playerController = playerController;
			combatController.worldController = worldController;
			combatController.characterDataManager = characterDataManager;
			combatController.uiController = uiController;
			uiController.partyController = partyController;
			
			LevelLoader.stageRef = stage;
			LevelLoader.playerController = playerController;
			LevelLoader.worldController = worldController;
			LevelLoader.combatController = combatController;
			LevelLoader.characterDataManager = characterDataManager;
			
			// listeners
			uiController.addEventListener(UIControllerBase.EVENT_RESULT_REQUEST, onResultsRequested);
			uiController.addEventListener(UIControllerBase.EVENT_DIALOGUE_COMPLETE, onDialogueCompleteEvent);
			
		} // end of function init initControllers
		
		private function initExternals():void
		{
			SpriteSwapper.loadSWFs(["SpriteAtlas.swf", "MainMenu.swf", "UIAtlas.swf"]);
			SpriteSwapper.dispatcher.addEventListener(EVENT_LOADING_COMPLETE, onInitExternalsComplete);
			
			//loads character XML
			XMLLoader.dispatcher.addEventListener(EVENT_LOADING_COMPLETE, onXMLsLoaded);
			XMLLoader.loadXMLs(["data/XML/CharacterList.xml", "data/XML/LevelList.xml", "data/XML/DialogueList.xml", "data/XML/WeaponList.xml", "data/XML/ItemList.xml"]);
		} // end of function initExternals
		
		private function debug():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDebugKey);
			stage.addEventListener(MouseEvent.CLICK, onDebugClick);
		} // end of function debug
		
		private function onDebugKey(event:KeyboardEvent):void 
		{
			switch(event.keyCode)
			{
				/*case Keyboard.Q:
					uiController.show("dialogue");
					var dialogue:MovieClip = uiController.getUIElement("dialogue");
					
					dialogue.setDialogue( { character: "MasterChief_Dialogue", side: "right", name: "Master Chief", message: "You seem like a friendly. Where is this place?" } );
					//world.visible = false;
					break;*/
				case Keyboard.Z:
					//var newChar1:MovieClip = characterDataManager.generateNewCharacter("SailorMoon", 5);
					var newChar2:MovieClip = characterDataManager.generateNewCharacter("Mewtwo", 5);
					var newChar3:MovieClip = characterDataManager.generateNewCharacter("Goomba", 5);
					(newChar3 as Character).HP = 0;
					//partyController.addItem("active", newChar1 as Character);
					partyController.addItem("active", newChar2 as Character);
					partyController.addItem("active", newChar3 as Character);
					break;
				case Keyboard.E:
					//lightingController.setAmbientLight(0x7fd7ff, combatContainer, { alpha: 0.4, blendMode: "multiply" } );
					uiController.show("battleLog");
					var bLog:MovieClip = uiController.getUIElement("battleLog");
					bLog.generateLog("Test 1");
					bLog.generateLog("Test 2");
					bLog.generateLog("Test 3");
					break;
				case Keyboard.X:
					world.visible = false;
					// loads bg
					//levelController.loadBG("CombatBackground_Test");
					
					// chars
					var testChar1:MovieClip = characterDataManager.generateNewCharacter("Mewtwo", 5);
					var testChar2:MovieClip = characterDataManager.generateNewCharacter("SailorMoon", 5);
					var testChar3:MovieClip = characterDataManager.generateNewCharacter("ChunLi", 5);
					var testChar4:MovieClip = characterDataManager.generateNewCharacter("MasterChief", 5);
					
					partyController.removeAll();
					partyController.addItem("active", testChar1 as Character);
					partyController.addItem("active", testChar2 as Character);
					partyController.addItem("active", testChar3 as Character);
					partyController.addItem("active", testChar4 as Character);
					
					var testEnemy1:MovieClip = characterDataManager.generateNewCharacter("Goomba");
					var testEnemy2:MovieClip = characterDataManager.generateNewCharacter("Goomba");
					var testEnemy3:MovieClip = characterDataManager.generateNewCharacter("Goomba");
					var testEnemy4:MovieClip = characterDataManager.generateNewCharacter("Goomba");
					
					combatController.spawnCharacters([testChar1, testChar2, testChar3, testChar4], [testEnemy1, testEnemy2, testEnemy3, testEnemy4]);
					//UI.show("combatBar");
					break;
			} // end of switch
		} // end of function onDebugKey
		
		private function onDebugClick(event:MouseEvent):void
		{
			trace ("DEBUG CLICK: " + event.target + ", " + event.target.parent.name + "." + event.target.name);
		} // end of function onDebugClick
		
		private function onXMLsLoaded(event:Event):void
		{
			XMLLoader.dispatcher.removeEventListener(EVENT_LOADING_COMPLETE, onXMLsLoaded);
			characterDataManager.characterList = XMLLoader.getLoadedXML("CharacterList");
		} // end of function onXMLLoaded
		
		private function onInitExternalsComplete(event:Event):void
		{
			trace ("Main::onInitExternalsComplete");
			SpriteSwapper.dispatcher.removeEventListener(EVENT_LOADING_COMPLETE, onInitExternalsComplete);
			showInitialMovie();
		} // end of function onInitExternalsComplete
		
		private function onResultsRequested(event:EventWithData):void
		{	// Main is handling this because it has access to all controllers
			if (event.data.results == null) return;
			
			for (var i:int = 0; i < event.data.results.length; i++)
				applyResult(event.data.results[i]);
		} // end of function onResultsRequested
		
		private function applyResult(params:Object):void
		{	// applies a specific type of result
			// parameter check.
			if (params.type == null || params.value == null) return;
			
			// at this point, should have all the data needed to continue.
			trace ("Main::applyResult " + params.type + ", " + params.value);
			
			var resultType:String = params.type;
			
			switch(resultType)
			{
				case "addNewChar":
					trace ("adding new character! " + params.value);
					var newChar:Character = characterDataManager.generateNewCharacter(params.value, params.level != null ? params.level : 5) as Character;
					
					if (params.weapon != null)
						newChar.equipWeapon(new Weapon(params.weapon));
					partyController.addItem("active", newChar);
					break;
				case "combat":
					trace ("COMBAT RESULT. " + params.enemies);
					combatController.forceTriggerCombat(params.enemies);
					break;
				case "quest":
					trace ("Quest result attempted. Quest flow needs to be created");
					break;
				case "removeFromWorld":
					worldController.destroyEntity(params.value);
					break;
			} // end of switch
		} // end of function applyResult
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GAME FLOW FUNCTIONS                                            //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function showInitialMovie():void
		{	// loads and shows the splash screen
			var splashScreen:MovieClip = SpriteSwapper.getSprite("InitialMovie");
			
			// null check!
			if (splashScreen == null) return;
			
			// add to screen
			stage.addChild(splashScreen);
			splashScreen.x = 0;
			splashScreen.y = 0;
			splashScreen.gotoAndPlay(1);
			splashScreen.addEventListener(Event.ENTER_FRAME, onSplashScreenFrameTick);
		} // end of function showInitialMovie
		
		private function onSplashScreenFrameTick(event:Event):void
		{	// RUN ONCE PER FRAME
			var target:MovieClip = event.target as MovieClip;
			
			// null check
			if (target == null) return;
			
			// don't continue if it hasn't reached the end
			if (target.currentFrame < target.totalFrames) return;
			
			// Past this point, it's assumed to have reached the final frame
			target.removeEventListener(Event.ENTER_FRAME, onSplashScreenFrameTick);
			stage.removeChild(target);
			
			// show actual menu
			showMainMenu();
		} // end of function onSplashScreenFrameTick
		
		private function showMainMenu():void
		{
			var menuClip:MovieClip = SpriteSwapper.getSprite("MainMenu_UI");
			
			if (menuClip == null) return;
			
			// add to screen
			stage.addChild(menuClip);
			menuClip.x = 0; 
			menuClip.y = 0;
			menuClip.name = "mainMenu";
			
			menuClip.buttonClickedCallback = onMainMenuButtonClicked;
		} // end of function showMainMenu
		
		private function onMainMenuButtonClicked(stringID:String):void
		{
			trace ("MAIN MENU BUTTON CLICKED " + stringID);
			var menuClip:MovieClip = stage.getChildByName("mainMenu") as MovieClip;
			
			// null check
			if (menuClip == null) return;
			
			stage.removeChild(menuClip);
			
			// do stuff based on what button was clicked!
			switch(stringID)
			{
				case "btn_newGame":
					startNewGame();
					break;
				default:
					throw new Error("invalid button cliked. Main::onMainMenuButtonClicked");
					break;
			} // end of switch
			
		} // end of function onMainMenuButtonClicked
		
		private function startNewGame():void
		{
			if (worldController != null)
				worldController.startNewGame();
				
			if (partyController != null)
			{
				partyController.startNewGame();
			} // end of playerController
			
		} // end of function startNewGame
		
		private function onDialogueCompleteEvent(event:Event):void
		{
			if (playerController != null)
				playerController.isMovable = true;
		} // end of function onDialogueCompleteEvent
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
	} // end of class Main
	
} // end of package src
