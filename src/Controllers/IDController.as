package src.Controllers
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE: This class is the master controller for all generated ID's.
	 */
	public class  IDController extends MovieClip
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private static var nextID_char:int = -1;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function IDController() { }
	
		public static function get newCharID():int
		{
			nextID_char++;
			return nextID_char;
		} // end of function get new charID
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	} // end of class IDController
	
} // enDate of package src.Controllers