package src.Controllers.WorldMenu 
{
	
	import flash.display.MovieClip;
	import src.Entities.Item;
	
	
	public class InventoryItem extends MovieClip 
	{
		
		public var item:Item;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function InventoryItem() 
		{
			// constructor code
		} // end of constructor function
		
		public function setData($item:Item):void
		{
			item = $item;
		} // end of function setData
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	} // end of class InventoryItem
	
} // end of package src.controllers.worldMenu
