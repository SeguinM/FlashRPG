package src.Controllers
{
	import flash.display.MovieClip;
	import src.Entities.Character;
	import src.Utilities.SpriteSwapper;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE:
	 * This class is responsible for reading, generating, and tracking all characters.
	 */
	public class  CharacterDataManager extends MovieClip
	{
		
		// VARIABLES
		private var $characterList:XML;
		
		// externally assigned:
		public var partyController:PartyController;
		public var uiController:UIControllerBase;
	
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CharacterDataManager()
		{
			// DO STUFF
		} // end of function CharacterDataManager
		
		public function generateNewCharacter(stringID:String, level:int = 1):MovieClip
		{
			var charXML:XML;         // temporary var for the single character XML we need
			var charList:XMLList;    // Array that stores all found 'character' elements
			
			charList = characterList.character;      // Looks weird, but assigns all instances of 'character' elements to this array
			
			// iterates through the XMLList and assigns to charXML
			for each (var $character:XML in charList)
			{
				// checks to make sure the $character xml object has the attribute 'id' before checking
				if ($character.attribute("id"))
				{
					trace ("For loop iteration");
					if ($character.@id == stringID)
					{
						charXML = $character;
						break;
					} // end of nested if statement
				} // end of if statements
			} // end of for loop
			
			// checks to see if charXML is null before continuing
			if (charXML == null) return new MovieClip();
			
			// Creates a tangible stage object
			var newChar:Character = new Character(IDController.newCharID);
			
			// has flash entity? to replace stand-in
			if (charXML.elements("flashEntity"))
			{
				while (newChar.numChildren > 0)
					newChar.removeChildAt(0);
				
				// character asset
				var spriteClip:MovieClip = SpriteSwapper.getSprite(charXML.flashEntity) as MovieClip; 
				newChar.addChild(spriteClip);
				spriteClip.x = 0;
				spriteClip.y = 0;
			} // end of if statement
			
			generateStats(newChar, charXML, level);
			
			// Pass in any additional externals such as controller scripts
			if (uiController != null)
				newChar.uiController = uiController;
				
			// mouse interaction
			newChar.mouseChildren = false;
			
			return newChar as MovieClip;
		} // end of function generateNewCharacter
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function generateStats(newChar:MovieClip, charXML:XML, level:int):void
		{
			trace (newChar);
				
			// no point in continuing if entity was null
			if (!charXML.elements("flashEntity") || !newChar)
				return;
				
			trace ("CharacterDataManager::generateStats passed null check");
				
			// level?
			(newChar as Character).LEVEL = 1;
			(newChar as Character).EXP_MAX = 100;
			// name?
			if (charXML.elements("characterName"))
				newChar.setCharacterName = charXML.characterName;
				
			// hp?
			if (charXML.elements("hp"))
			{
				if (charXML.hp.attribute("min") && charXML.hp.attribute("max"))
				{
					newChar.HP_MAX = Math.floor(Math.random() * (parseInt(charXML.hp.@max) - parseInt(charXML.hp.@min) + 1)) + parseInt(charXML.hp.@min);
					newChar.HP = newChar.HP_MAX;
					newChar.lvlUp_hp_min = parseInt(charXML.hp.@min) / 4;
					newChar.lvlUp_hp_max = parseInt(charXML.hp.@max) / 4;
					trace (newChar.HP);
				} // end of nested if statement
			} // end of if statement
			
			// ap?
			if (charXML.elements("ap"))
			{
				if (charXML.ap.attribute("min") && charXML.ap.attribute("max"))
				{
					newChar.AP_MAX = Math.floor(Math.random() * (parseInt(charXML.ap.@max) - parseInt(charXML.ap.@min) + 1)) + parseInt(charXML.ap.@min);
					newChar.AP = newChar.AP_MAX;
					trace (newChar.AP);
				} // end of nested if statement
			} // end of if statement
			
			// patk?
			if (charXML.elements("patk"))
			{
				if (charXML.patk.attribute("min") && charXML.patk.attribute("max"))
				{
					newChar.P_ATK = Math.floor(Math.random() * (parseInt(charXML.patk.@max) - parseInt(charXML.patk.@min) + 1)) + parseInt(charXML.patk.@min);
					newChar.lvlUp_patk_min = parseInt(charXML.patk.@min) / 2;
					newChar.lvlUp_patk_max = parseInt(charXML.patk.@max) / 2;
					trace (newChar.P_ATK);
				} // end of nested if statement
			} // end of if statement
			
			// ratk?
			if (charXML.elements("ratk"))
			{
				if (charXML.ratk.attribute("min") && charXML.ratk.attribute("max"))
				{
					newChar.R_ATK = Math.floor(Math.random() * (parseInt(charXML.ratk.@max) - parseInt(charXML.ratk.@min) + 1)) + parseInt(charXML.ratk.@min);
					newChar.lvlUp_ratk_min = parseInt(charXML.ratk.@min) / 2;
					newChar.lvlUp_ratk_max = parseInt(charXML.ratk.@max) / 2;
					trace (newChar.R_ATK);
				} // end of nested if statement
			} // end of if statement
			
			// matk?
			if (charXML.elements("matk"))
			{
				if (charXML.matk.attribute("min") && charXML.matk.attribute("max"))
				{
					newChar.M_ATK = Math.floor(Math.random() * (parseInt(charXML.matk.@max) - parseInt(charXML.matk.@min) + 1)) + parseInt(charXML.matk.@min);
					newChar.lvlUp_matk_min = parseInt(charXML.matk.@min) / 2;
					newChar.lvlUp_matk_max = parseInt(charXML.matk.@max) / 2;
					trace (newChar.M_ATK);
				} // end of nested if statement
			} // end of if statement
			
			// satk?
			if (charXML.elements("satk"))
			{
				if (charXML.satk.attribute("min") && charXML.satk.attribute("max"))
				{
					newChar.S_ATK = Math.floor(Math.random() * (parseInt(charXML.satk.@max) - parseInt(charXML.satk.@min) + 1)) + parseInt(charXML.satk.@min);
					newChar.lvlUp_satk_min = parseInt(charXML.satk.@min) / 2;
					newChar.lvlUp_satk_max = parseInt(charXML.satk.@max) / 2;
					trace (newChar.S_ATK);
				} // end of nested if statement
			} // end of if statement
			
			
			
			
			// pdef?
			if (charXML.elements("pdef"))
			{
				if (charXML.pdef.attribute("min") && charXML.pdef.attribute("max"))
				{
					newChar.P_DEF = Math.floor(Math.random() * (parseInt(charXML.pdef.@max) - parseInt(charXML.pdef.@min) + 1)) + parseInt(charXML.pdef.@min);
					newChar.lvlUp_pdef_min = parseInt(charXML.pdef.@min) / 2;
					newChar.lvlUp_pdef_max = parseInt(charXML.pdef.@max) / 2;
					trace (newChar.P_DEF);
				} // end of nested if statement
			} // end of if statement
			
			// rdef?
			if (charXML.elements("rdef"))
			{
				if (charXML.rdef.attribute("min") && charXML.rdef.attribute("max"))
				{
					newChar.R_DEF = Math.floor(Math.random() * (parseInt(charXML.rdef.@max) - parseInt(charXML.rdef.@min) + 1)) + parseInt(charXML.rdef.@min);
					newChar.lvlUp_rdef_min = parseInt(charXML.rdef.@min) / 2;
					newChar.lvlUp_rdef_max = parseInt(charXML.rdef.@max) / 2;
					trace (newChar.R_DEF);
				} // end of nested if statement
			} // end of if statement
			
			// mdef?
			if (charXML.elements("mdef"))
			{
				if (charXML.mdef.attribute("min") && charXML.mdef.attribute("max"))
				{
					newChar.M_DEF = Math.floor(Math.random() * (parseInt(charXML.mdef.@max) - parseInt(charXML.mdef.@min) + 1)) + parseInt(charXML.mdef.@min);
					newChar.lvlUp_mdef_min = parseInt(charXML.mdef.@min) / 2;
					newChar.lvlUp_mdef_max = parseInt(charXML.mdef.@max) / 2;
					trace (newChar.M_DEF);
				} // end of nested if statement
			} // end of if statement
			
			// sdef?
			if (charXML.elements("sdef"))
			{
				if (charXML.sdef.attribute("min") && charXML.sdef.attribute("max"))
				{
					newChar.S_DEF = Math.floor(Math.random() * (parseInt(charXML.sdef.@max) - parseInt(charXML.sdef.@min) + 1)) + parseInt(charXML.sdef.@min);
					newChar.lvlUp_sdef_min = parseInt(charXML.sdef.@min) / 2;
					newChar.lvlUp_sdef_max = parseInt(charXML.sdef.@max) / 2;
					trace (newChar.S_DEF);
				} // end of nested if statement
			} // end of if statement
			
			// speed?
			if (charXML.elements("speed"))
			{
				if (charXML.speed.attribute("min") && charXML.speed.attribute("max"))
				{
					newChar.SPEED = Math.floor(Math.random() * (parseInt(charXML.speed.@max) - parseInt(charXML.speed.@min) + 1)) + parseInt(charXML.speed.@min);
					newChar.lvlUp_speed_min = parseInt(charXML.speed.@min) / 2;
					newChar.lvlUp_speed_max = parseInt(charXML.speed.@max) / 2;
					trace (newChar.SPEED);
				} // end of nested if statement
			} // end of if statement
			
			// if level is higher than 1, level up!
			if (level > 1)
			{
				for (var i:int = 0; i < level - 1; i++)
					newChar.levelUp();
			} // end of for loop
		} // end of function generateStats
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function set characterList(file:XML):void
		{
			$characterList = file;
		} // end of function set characterList
		
		public function get characterList():XML
		{
			return $characterList;
		} // end of function 
		
	} // end of class CharacterDataManager
	
} // enDate of package src.Controllers