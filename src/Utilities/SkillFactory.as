package src.Utilities
{
	import flash.display.MovieClip;
	import src.Entities.Character;
	
	/**
	 * ...
	 * @author SeguinM
	 * EXPECTED PARAMETERS:
	 * goodGuys (array)
	 * badGuys (array)
	 * perpetrator (character)
	 * defender (character)
	 */
	public class  SkillFactory extends MovieClip
	{
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function SkillFactory() { } // constructor function
		
		public static function useItem(stringID:String, params:Object):void
		{
			var skillFunction:Function;
			
			skillFunction = getEffectByName(stringID);
			
			skillFunction(params);
			
		} // end of function useItem
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function getEffectByName(stringID:String):Function
		{ 	// One massive switch to get the proper function noted in SkillEffectFunctions.
			switch(stringID)
			{
				default:
					return null;
					break;
			} // end of switch
		} // end of static function getEffectByName
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                             ITEM EFFECT FUNCTIONS                                             //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function _mushroom(params:Object):void
		{
			if (params.defender != null)
			{
				if (params.defender.HP != 0)
					params.defender.healHP(50);
			} // end of if statement
		} // end of static function _mushroom
		
	} // end of class SkillFactory
	
} // end of package src.Utilities