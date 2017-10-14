package src.Controllers.WorldMenu 
{
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import src.Controllers.DynamicButton;
	import src.Entities.Character;
	
	
	public class PartyItem extends DynamicButton 
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var internalCharacter:Character;
		
		private static const BAR_COLOR_MAX:uint = 0x339900;
		private static const BAR_COLOR_MED:uint = 0xCCCC33;
		private static const BAR_COLOR_MIN:uint = 0x990000;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function PartyItem() 
		{
			super();
			// constructor code
		} // end of constructor function
		
		public function setData(character:Character):void
		{
			internalCharacter = character;
			setStaticTextFields();
			setVariableTextFields();
			setBars();
		} // end of function setData
		
		public function getCharacter():Character
		{
			trace ("getting character");
			return internalCharacter;
		} // end of function getCharacter
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function setStaticTextFields():void
		{
			weaponTitle.text = "WEAPON:";
			classTitle.text = "CLASS:";
			speedTitle.text = "SPEED:";
			
			patkTitle.text = "PHYS. STR:";
			ratkTitle.text = "RANGED STR:";
			matkTitle.text = "MAGIC STR:";
			satkTitle.text = "SOUL STR:";
			
			pdefTitle.text = "PHYS. DEF:";
			rdefTitle.text = "RANGED DEF:";
			mdefTitle.text = "MAGIC DEF:";
			sdefTitle.text = "SOUL DEF:";
		} // end of function setStaticTextFields
		
		private function setVariableTextFields():void
		{
			if (internalCharacter == null) return;
			
			nameTxt.text = internalCharacter.characterName.toUpperCase();
			lvlTxt.text = "Lv. " + internalCharacter.LEVEL;
			hpTxt.text = "HP: " + internalCharacter.HP + " / " + internalCharacter.HP_MAX;
			
			weaponTxt.text = internalCharacter.equippedWeapon == null ? "None" : internalCharacter.equippedWeapon.weaponName;
			classTxt.text = "None";
			speedTxt.text = String(internalCharacter.SPEED);
			
			patk.text = String(internalCharacter.P_ATK);
			ratk.text = String(internalCharacter.R_ATK);
			matk.text = String(internalCharacter.M_ATK);
			satk.text = String(internalCharacter.S_ATK);
			
			pdef.text = String(internalCharacter.P_DEF);
			rdef.text = String(internalCharacter.R_DEF);
			mdef.text = String(internalCharacter.M_DEF);
			sdef.text = String(internalCharacter.S_DEF);
		} // end of function setVariableTextFields
		
		private function setBars():void
		{
			if (internalCharacter == null) return;
			
			hp.hpBar.scaleX = internalCharacter.HP / internalCharacter.HP_MAX;
			
			// adjusts hp bar color
			// adjusts color of hp bar
			var bar:Shape = hp.hpBar.getChildAt(0) as Shape;
			var barWidth:Number = bar.width;
			var barHeight:Number = bar.height;
			bar.graphics.beginFill(getBarColor(), 1);
			bar.graphics.drawRect(0, 0, barWidth, barHeight);
			bar.graphics.endFill();
			
			exp.bar.scaleX = internalCharacter.EXP / internalCharacter.EXP_MAX;
		} // end of function setBars
		
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
		//                                               	GETTERS / SETTER                                             //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/*private function get character():Character
		{
			trace ("PartyItem -- retrieving character...");
			return internalCharacter;
		} // end of function get character*/
		
	} // end of class PartyItem
	
} // end of package src.Controllers.WorldMenu
