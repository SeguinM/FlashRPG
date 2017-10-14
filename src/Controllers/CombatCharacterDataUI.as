package src.Controllers 
{
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import src.Entities.Character;
	import src.Events.EventWithData;
	
	
	public class CombatCharacterDataUI extends MovieClip
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var internalID:int;
		private var internalCharacter:Character;
		
		// STATIC CONSTS---------------------------------------------------------------------------------------------------
		
		private static const BAR_COLOR_MAX:uint = 0x339900;
		private static const BAR_COLOR_MED:uint = 0xCCCC33;
		private static const BAR_COLOR_MIN:uint = 0x990000;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CombatCharacterDataUI() 
		{
			super();
			init();
		} // end of function CombatCharacterDataUI
		
		public function setData(character:Character):void
		{
			trace ("SET CHAR UI DATA");
			hpTxt.text = character.HP + " / " + character.HP_MAX;
			nameTxt.text = character.characterName + "  lv." + character.LEVEL;
			apTxt.text = character.AP + " / " + character.AP_MAX;
			weaponTxt.text = character.equippedWeapon == null ? "None" : character.equippedWeapon.weaponName;
			
			internalCharacter = character;
			
			internalID = character.id;
			
			updateHPBar(character.HP, character.HP_MAX);
			updateEXPBar(character.EXP, character.EXP_MAX);
			
			character.addEventListener(Character.EVENT_DATA_CHANGE, onDataChanged);
		} // end of function setData
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			// DO STUFF
		} // end of function init
		
		private function onDataChanged(event:EventWithData):void
		{
			if (internalCharacter == null) return;
			
			trace ("updating UI");
			
			updateHPBar(internalCharacter.HP, internalCharacter.HP_MAX);
			updateEXPBar(internalCharacter.EXP, internalCharacter.EXP_MAX);
			
			hpTxt.text = internalCharacter.HP + " / " + internalCharacter.HP_MAX;
			nameTxt.text = internalCharacter.characterName + "  lv." + internalCharacter.LEVEL;
			apTxt.text = internalCharacter.AP + " / " + internalCharacter.AP_MAX;
			weaponTxt.text = "None";
		} // end of function onDamageTaken
		
		private function updateHPBar(hp_curr:int, hp_max:int):void
		{
			hp.hpBar.scaleX = hp_curr / hp_max;
			hpTxt.text = hp_curr + " / " + hp_max;
			
			// adjusts color of hp bar
			var bar:Shape = hp.hpBar.getChildAt(0) as Shape;
			var barWidth:Number = bar.width;
			var barHeight:Number = bar.height;
			bar.graphics.beginFill(getBarColor(), 1);
			bar.graphics.drawRect(0, 0, barWidth, barHeight);
			bar.graphics.endFill();
			
		} // end of function updateHPBar
		
		private function updateEXPBar(exp_curr:int, exp_max:int):void
		{
			exp.bar.scaleX = exp_curr / exp_max;
		} // end of function updateEXPBar
		
		private function getBarColor():uint
		{
			var bar:MovieClip = hp.hpBar;
			
			if (bar.scaleX <= 0.25)
				return BAR_COLOR_MIN;
			else if (bar.scaleX <= 0.5 && bar.scaleX > 0.25)
				return BAR_COLOR_MED;
			else
				return BAR_COLOR_MAX;
		} // end of function getBarColor
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get id():int
		{
			return internalID;
		} // end of function get id
		
		public function get character():Character
		{
			return internalCharacter;
		} // end of function get character
		
	} // end of class CombatCharacterDataUI
	
} // end of class src.Controllers
