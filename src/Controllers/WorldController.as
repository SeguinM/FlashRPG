package src.Controllers
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import src.Entities.CharacterEntity;
	import src.Events.EventWithData;
	import src.Main;
	import src.Utilities.DialogueUtility;
	import src.Utilities.LevelLoader;
	import src.Utilities.SpriteSwapper;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class WorldController extends MovieClip 
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var stageRef:Stage;                     // stage reference
		private var world:MovieClip;                    // World reference
		private var combatContainer:MovieClip;          // combat container reference
		
		private var gamestate:String = "overworld";
		
		// EXTERNALLY ASSIGNED REFERENCES----------------------------------------------------------------------------------
		
		public var playerController:PlayerController;
		public var partyController:PartyController;
		
		// CONSTS
		
		public static const EVENT_CHARACTER_ENTITY_CLICKED:String = "CharacterEntityClickedEvent";
		public static const EVENT_ADD_INVENTORY:String = "onAddInventoryEvent";
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function WorldController($stageRef:Stage, $worldRef:MovieClip, $combatContainer:MovieClip)
		{
			init($stageRef, $worldRef, $combatContainer);
		} // end of constructor function
		
		public function startNewGame():void
		{	// Called when a new game is to be started
			clearWorld();
			
			if (world == null) return;
			
			LevelLoader.dispatcher.addEventListener(LevelLoader.EVENT_LOADING_COMPLETE, onLevelLoaded);
			LevelLoader.loadLevel("Level000Chunk000", world, combatContainer);
			
			//SpriteSwapper.dispatcher.addEventListener(SpriteSwapper.EVENT_LOADING_COMPLETE, onLevelAtlasLoaded);
			//SpriteSwapper.loadSWFs(["LevelAtlas000.swf"]);
			
		} // end of function startNewGame
		
		public function getEntityByName(target:String):MovieClip
		{
			var ret:MovieClip;
			ret = level.getChildByName(target) as MovieClip;
			//trace ("target name: " + target + ", found: " + ret + ", " + ret.name);
			return ret;
		} // end of function getEntityByName
		
		public function setGameMode(state:String):void
		{
			// sets gamestate strinig
			gamestate = state;
			
			switch(state)
			{
				case "combat":
					world.visible = false;
					combatContainer.visible = true;
					break;
				case "overworld":
					world.visible = true;
					combatContainer.visible = false;
					break;
				default:
					throw new Error("invalid game mode set at WorldController::setGameMode");
					break;
			} // end of switch
		} // end of function setGameMode
		
		public function destroyEntity(stringID:String):void
		{
			var tgt:DisplayObject = level.getChildByName(stringID);
			
			if (tgt == null) return;
			
			level.removeChild(tgt);
			
			trace ("WorldController::destroyEntity successful");
		} // end of function destroyEntity
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($stageRef:Stage, $worldRef:MovieClip, $combatContainer:MovieClip):void
		{
			stageRef = $stageRef;
			combatContainer = $combatContainer;
			world = $worldRef;
		} // end of function init
		
		private function clearWorld():void
		{	// empties out world container
			if (world == null) return;
			
			while (world.numChildren > 0)
				world.removeChildAt(0);
		} // end of function clearWorld
		
		private function onLevelLoaded(event:Event):void
		{
			// remove listener
			LevelLoader.dispatcher.removeEventListener(LevelLoader.EVENT_LOADING_COMPLETE, onLevelLoaded);
			
			initLevelListeners();
			trace ("\n\n\nfinish loading sequence\n\n\n");
		} // end of function onLevelAtlasLoaded
		
		private function initLevelListeners():void
		{	// called once level is done loading
			level.addEventListener(EVENT_CHARACTER_ENTITY_CLICKED, onCharacterEntityClicked);
			level.addEventListener(EVENT_ADD_INVENTORY, onInventoryAddEvent);
			
			if (LevelLoader.loadedLevelType == LevelLoader.LEVEL_TYPE_CINEMATIC)
			{
				level.addEventListener(Event.ENTER_FRAME, onCinematicFrameTick);
			}
		} // end of function initLevelListeners
		
		private function onCinematicFrameTick(event:Event)
		{
			// Check for dialogue
			if (level.currentFrameLabel && level.currentFrameLabel.indexOf("Dialogue") > -1)
			{
				level.stop();
				level.removeEventListener(Event.ENTER_FRAME, onCinematicFrameTick);
				
				var diagController:MovieClip = playerController.uiController.getUIElement("dialogue");
				diagController.addEventListener(DialogueController.EVENT_DIALOGUE_COMPLETE, onCinematicDialogueComplete);
				
				if (diagController == null) return;
				
				var dialogueEntryStr:String = level.currentFrameLabel.split(":")[1]; // grabs actual dialogue entry name
				trace ("dialogue entry string: " + dialogueEntryStr);
				var dialogue:Array = DialogueUtility.getDialogueEntry(dialogueEntryStr);
				
				playerController.uiController.show("dialogue");
				
				diagController.playDialogueEntry(dialogue);
			}
			// Check for end
			if (level.currentFrame == level.totalFrames)
			{
				trace("end of cinematic");
				level.stop();
				level.removeEventListener(Event.ENTER_FRAME, onCinematicFrameTick);
				
				//Load next level
				LevelLoader.loadLevel(LevelLoader.queuedNextLevel, world, combatContainer);
			}
		}
		
		private function onCinematicDialogueComplete(event:Event)
		{
			var diagController:MovieClip = playerController.uiController.getUIElement("dialogue");
			diagController.removeEventListener(DialogueController.EVENT_DIALOGUE_COMPLETE, onCinematicDialogueComplete);
			playerController.uiController.hide("dialogue");
			
			level.play();
			level.addEventListener(Event.ENTER_FRAME, onCinematicFrameTick);
		}
		
		private function onCharacterEntityClicked(event:EventWithData):void
		{
			// whole bunch of checks before continuing.
			if (playerController == null) return;
			if (playerController.isMovable != true) return;
			if (gamestate != "overworld") return;
			if (event.data.character == null) return;
			
			playerController.isMovable = false;
			
			event.data.character.interact();
		} // end of function onCharacterEntityClicked
		
		private function onInventoryAddEvent(event:EventWithData):void
		{
			trace ("INVENTORY ADD EVENT");
			var newInventory:Array = event.data.inventory;
			
			if (newInventory == null) return;
			if (newInventory.length < 1) return;
			if (partyController == null) return;
			
			partyController.addInventory(newInventory);
		} // end of function onInventoryAddEvent
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function get level():MovieClip
		{
			if (world != null)
			{
				if (world.getChildByName("level") != null)
					return world.getChildByName("level") as MovieClip;
			} // end of world
			
			// If it reaches this point, it shouldn't have a 'level' child? verify plz
			return null;
		} // end of function get level
		
		public function get player():MovieClip
		{
			if (world != null)
			{
				if (world.getChildByName("player") != null)
					return world.getChildByName("player") as MovieClip;
			} // end of if statement
			
			// if it reaches this point, player child should not be present otherwise there's an issue. verify plz
			return null;
		} // end of function get player
		
		public function get gameState():String
		{
			return gamestate;
		} // end of function get gamestate;
		
	} // end of class WorldController
	
} // end of package src.Controllers