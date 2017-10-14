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
	public class  ItemFactory extends MovieClip
	{
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function ItemFactory() { } // constructor function
		
		public static function useItem(stringID:String, params:Object):void
		{
			var effectFunction:Function;
			
			effectFunction = getEffectByName(stringID);
			
			effectFunction(params);
			
		} // end of function useItem
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function getEffectByName(stringID:String):Function
		{ 	// One massive switch to get the proper function noted in ItemEffectFunctions.
			switch(stringID)
			{
				case "Mushroom":
					return _mushroom;
					break;
				case "GreenMushroom":
					return _greenMushroom;
					break;
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
		
		private static function _greenMushroom(params:Object):void
		{
			if (params.defender.HP == 0)
				params.defender.healHP((params.defender as Character).HP_MAX / 4);
		} // end of static function _greenMushroom
		
	} // end of class ItemFactory
	
} // end of package src.Utilities