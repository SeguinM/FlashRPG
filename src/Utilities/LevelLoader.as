package src.Utilities
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import src.Controllers.CharacterDataManager;
	import src.Controllers.CombatController;
	import src.Controllers.PlayerController;
	import src.Controllers.WorldController;
	import src.Entities.Character;
	import src.Entities.CharacterEntity;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE: static Utility class for loading levels and relevant data.
	 */
	public class  LevelLoader extends MovieClip
	{
		
		// CONTSTS
		public static const EVENT_LOADING_COMPLETE:String = "onAllSWFsComplete";
		public static const LEVEL_TYPE_GAMEPLAY:String = "gameplay";
		public static const LEVEL_TYPE_CINEMATIC:String = "cinematic";
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		public static var stageRef:Stage;
		public static var playerController:PlayerController;
		public static var worldController:WorldController;
		public static var combatController:CombatController;
		public static var characterDataManager:CharacterDataManager;
		
		private static var $dispatcher:EventDispatcher = new EventDispatcher();          // dispatcher to dispatch events
		private static var $levelList:XML;                                                      // stores XML main file
		private static var worldContainer:MovieClip;                                     // world container to store level
		private static var combatContainer:MovieClip;
		
		private static var queuedAsset:String = "";
		public static var loadedLevelType:String = "";                                   // Loaded level type (cinematic, gameplay)
		public static var queuedNextLevel:String = "";                                   // Next level queued up (for cinematics)
		private static var queuedLevelInstanceXML:XML = null;                            // queued level XML file
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function LevelLoader() 
		{ 
			$dispatcher = new EventDispatcher();
		} // end of constructor function
		
		public static function loadLevel(newLevelName:String, $worldContainer:MovieClip, $combatContainer:MovieClip):void
		{
			trace("LOAD_LEVEL");
			worldContainer = $worldContainer;
			combatContainer = $combatContainer;
			
			// if queuedAsset is not empty, a load is already in progress! abort!
			if (queuedAsset != "") return;
			
			var levelXML:XML = XMLLoader.getLoadedXML("LevelList");
			
			if (levelXML == null || worldContainer == null || stageRef == null) return;
			
			trace ("POST LEVEL XML LOAD");
			
			var levelInstanceXML:XML;         // temporary var for the single level XML we need
			var levelXMLList:XMLList;            // Array that stores all found 'level' elements
			
			levelXMLList = levelXML.level;      // Looks weird, but assigns all instances of 'level' elements to this array
			
			// iterates through the XMLList and assigns to levelInstanceXML
			for each (var $level:XML in levelXMLList)
			{
				trace ("Level Loader for loop iteration " + $level.@id + ", " + newLevelName);
				// checks to make sure the $character xml object has the attribute 'id' before checking
				if ($level.attribute("id"))
				{
					if ($level.@id == newLevelName)
					{
						trace ("FOUND LEVEL ATLAS");
						levelInstanceXML = $level;
						queuedLevelInstanceXML = new XML($level);
						break;
					} // end of nested if statement
				} // end of if statements
			} // end of for loop
			
			// null check!
			if (levelInstanceXML == null)
			{
				throw new Error("Unable to find level XML!");
			}
			
			// Time to load relevant atlas!
			if (levelInstanceXML.elements("file") && levelInstanceXML.elements("asset"))
			{
				queuedAsset = levelInstanceXML.asset;
				loadedLevelType = levelInstanceXML.type;
				
				if (levelInstanceXML.elements("nextLevel"))
				{
					queuedNextLevel = levelInstanceXML.nextLevel;
				}
				SpriteSwapper.dispatcher.addEventListener(SpriteSwapper.EVENT_LOADING_COMPLETE, onLevelFileLoaded);
				SpriteSwapper.loadSWFs([levelInstanceXML.file]);
			} // end of if statement
			
			// make more verbose in the future
			//var newLevel:MovieClip = SpriteSwapper.getSprite("Level000") as MovieClip;
		} // end of static function loadLevel
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function onLevelFileLoaded(event:Event):void
		{
			SpriteSwapper.dispatcher.removeEventListener(SpriteSwapper.EVENT_LOADING_COMPLETE, onLevelFileLoaded);
			trace ("LEVEL FILE LOADED THROUGH LEVEL LOADER");
			
			// loads level sprite
			var newLevel:MovieClip = SpriteSwapper.getSprite(queuedAsset) as MovieClip;
			
			if (newLevel == null || worldContainer == null) return;
			
			worldContainer.removeChildren();
			worldContainer.addChild(newLevel);
			newLevel.x = 0;
			newLevel.y = 0;
			newLevel.name = "level";
			
			if (loadedLevelType == LEVEL_TYPE_GAMEPLAY)
			{
				var newPlayer:MovieClip = SpriteSwapper.getSprite("WorldPlayerEntity");
				
				if (newPlayer == null) return;
				
				worldContainer.addChild(newPlayer);
				
				newPlayer.x = stageRef.stageWidth / 2;
				newPlayer.y = stageRef.stageHeight / 2;
				newPlayer.name = "player";
				
				if (playerController == null || worldController == null) return;
				
				playerController.isMovable = true;
				playerController.playerGraphic = worldController.player;
				
				var playerGraphic:MovieClip = SpriteSwapper.getSprite("Character_Luigi");
				
				// null check!
				if (playerGraphic == null) return;
				
				// clear out any children
				while (worldController.player.numChildren > 0)
					worldController.player.removeChildAt(0);
				
				worldController.player.addChild(playerGraphic);
				
				playerGraphic.scaleX = 0.5;
				playerGraphic.scaleY = 0.5;
				
				playerGraphic.y = 0 + (playerGraphic.height / 2);
				
				setLevelEntityData();
			}
			
			// clear queuedAsset
			queuedAsset = "";
			
			// finally, dispatch event
			$dispatcher.dispatchEvent(new Event(EVENT_LOADING_COMPLETE));
		} // end of function onLevelFileLoaded
		
		
		
		// ENTITY TYPE FUNCTION HUB-----------------------------------------------------------------------------------------------
		
		private static function setLevelEntityData():void
		{	// Finds and sets all relevant data for entities 
			if (queuedLevelInstanceXML == null) return;
			
			var entityXMLList:XMLList;
			
			entityXMLList = queuedLevelInstanceXML.entity;       // assigns all instances of entity within the XML level
			
			for each (var tag:XML in entityXMLList)
			{
				trace ("ENTITY FOR LOOP ITERATION " + tag.@type);
				if (tag.attribute("type"))
				{
					if (tag.@type == "EncounterVolume")
						setEncounterVolumeInstanceData(tag);
					if (tag.@type == "NewCharacterEntity")
						setNewCharacterInstanceData(tag);
					if (tag.@type == "Chest")
						setChestInstanceData(tag);
				} // end of if statement
			} // end of for each loop
			
			// sets combat bg
			if (queuedLevelInstanceXML.elements("combatBG"))
				loadCombatBG(queuedLevelInstanceXML.combatBG);
			
			// clear XML
			queuedLevelInstanceXML = null;
		} // end of function setLevelEntityData
		
		private static function setNewCharacterInstanceData(xmlData:XML):void
		{	// Processes and sets any New Character Entities in the world
			trace ("hit setNewCharacterInstanceData");
			if (worldController == null) return;
			if (characterDataManager == null) return;
			if (!xmlData.attribute("id")) return;
			
			var clip:MovieClip = worldController.getEntityByName(xmlData.@id);
			
			// clip null check
			if (clip == null) return;
			
			trace ("entity " + clip.name + " found successfully, ready for data parsing");
			
			var processedData:Object = { interactionType:String, character:Character, interactionID:String };
			
			if (xmlData.elements("charID"))
			{
				var newChar:MovieClip = characterDataManager.generateNewCharacter(xmlData.charID, xmlData.charID.attribute("level") == null ? 1 : parseInt(xmlData.charID.@level));
				processedData.character = newChar as Character;
			} // end of if statement
				
			if (xmlData.elements("interaction"))
			{
				if (xmlData.interaction.attribute("type"))
					processedData.interactionType = xmlData.interaction.@type;
				if (xmlData.interaction.attribute("id"))
					processedData.interactionID = xmlData.interaction.@id;
			} // end of if statement
			
			processedData.worldController = worldController;
			processedData.playerController = playerController;
			
			(clip as MovieClip).setData(processedData);
		} // end of static function setNewCharacterInstanceData
		
		private static function setEncounterVolumeInstanceData(xmlData:XML):void
		{	// Processes and sets any Encounter Volume Entities in the world
			trace ("hit setEncounterVolumeInstanceData");
			if (worldController == null) return;
			if (!xmlData.attribute("id")) return;
			
			var clip:MovieClip = worldController.getEntityByName(xmlData.@id)
			
			// additional null check!
			if (clip == null) return;
			
			trace ("entity " + clip.name + " found successfully, ready for data parsing");
			
			var enemySetList:XMLList = xmlData.enemySet;            // xml list of enemy sets
			var processedData:Object = { enemyList:Array, encounterRate:Number };         // processed dataObject to pass in
			processedData.enemyList = [];
			
			// encounter rate
			if (xmlData.attribute("encounterRate"))
				processedData.encounterRate = parseFloat(xmlData.@encounterRate);
			
			for each(var enemySet:XML in enemySetList)
			{
				var processedEnemySet:Object = { enemies:Array, chance:Number };       // processed data object to push into array
				processedEnemySet.enemies = [];
				
				if (enemySet.attribute("chance"))
					processedEnemySet.chance = parseFloat(enemySet.@chance);
				
				var enemyList:XMLList = enemySet.enemy;
				
				for each (var enemyXML:XML in enemyList)
				{
					var processedEnemy:Object = { stringID:String, lvl:int };
					if (enemyXML.attribute("id"))
						processedEnemy.stringID = enemyXML.@id;
					if (enemyXML.attribute("lvl"))
						processedEnemy.lvl = enemyXML.@lvl;
						
					processedEnemySet.enemies.push(processedEnemy);
				} // end of nested for each loop
				
				// push enemy set data to main object array
				processedData.enemyList.push(processedEnemySet);
			} // end of for each loop
			
			// assign controllers
			/*if (combatController != null)	
				clip.combatController = combatController as CombatController;
			if (playerController != null)
				clip.playerController = playerController as PlayerController;*/
			
			// finally, pass along data
			clip.setData(processedData);
		} // end of function setEncounterVolumeInstanceData
		
		private static function setChestInstanceData(xmlData:XML):void
		{
			trace ("hit setChestInstanceData");
			if (worldController == null) return;
			if (!xmlData.attribute("id")) return;
			
			var clip:MovieClip = worldController.getEntityByName(xmlData.@id)
			
			// additional null check!
			if (clip == null) return;
			
			trace ("entity " + clip.name + " found successfully, ready for data parsing");
			
			var itemList:XMLList = xmlData.item;        // assigns all instances of item
			var weaponList:XMLList = xmlData.weapon;    // all instances of weapon
			
			var processedData:Object = { weapons: [], items: [] }; // data object to put in processed XML data
			
			// process items
			for each (var $tag:XML in itemList)
			{
				if ($tag.attribute("id"))
					processedData.items.push($tag.@id);
			} // end of for each loop
			
			// process weapons
			for each (var _tag:XML in weaponList)
			{
				if (_tag.attribute("id"))
					processedData.weapons.push(_tag.@id);
			} // end of for each loop
			
			// money?
			if (xmlData.elements("money"))
				processedData.money = parseInt(xmlData.money);
				
			// finally, send data to ChestEntity to further process
			clip.setData(processedData);
		} // end of function setChestInstanceData
		
		private static function loadCombatBG($asset:String, stretchToSize:Boolean = false):void
		{
			var bg:MovieClip;
			bg = SpriteSwapper.getSprite($asset);
			
			// null check
			if (bg == null)
				return;
				
			// clears out bg container
			while (combatContainer.bg.numChildren > 0)
				combatContainer.bg.removeChildAt(0);
			
			combatContainer.bg.addChild(bg);
			combatContainer.bg.setChildIndex(bg, 0);
			
			bg.x = 0;
			bg.y = 0;
			bg.name = "bg";
			
			if (stretchToSize)
			{
				bg.width = combatContainer.width;
				bg.height = combatContainer.height;
				//trace ("Stage dimensions: " + stageRef.stageWidth + ", " + stageRef.stageHeight);
			} // end of stretchToSize
		} // end of function loadBG
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get dispatcher():EventDispatcher
		{
			return $dispatcher;
		} // end of function get dispatcher
		
	} // end of class LevelLoader
	
} // end of package src.Utilities