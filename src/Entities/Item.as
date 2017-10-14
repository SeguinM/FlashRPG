package src.Entities
{
	import flash.display.MovieClip;
	import src.Utilities.ItemFactory;
	import src.Utilities.XMLLoader;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class Item extends MovieClip
	{
		
		private var $itemName:String = "";
		private var $imageName:String = "";
		private var $description:String = "";
		
		private var internalID:String = "";
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Item(stringID:String)
		{
			generateFromXML(stringID);
		} // end of constructor item
		
		public function useItem(params:Object):void
		{
			ItemFactory.useItem(internalID, params);
		} // end of function useItem
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function generateFromXML(stringID:String):void
		{
			var xmlData:XML = XMLLoader.getLoadedXML("ItemList");
			
			if (xmlData == null) return;
			
			var xmlList:XMLList = xmlData.item;          // assigns all instances of item
			
			for each (var $tag:XML in xmlList)
			{
				if ($tag.attribute("id"))
				{
					if ($tag.@id == stringID)
					{
						internalID = stringID;
						setData($tag);
						break;
					} // end of nested if statement
				} // end of if statement
			} // end of for each loop
		} // end of function generateFromXML
		
		private function setData(xmlData:XML):void
		{
			if (xmlData.elements("flashEntity"))
				$imageName = xmlData.flashEntity;
			if (xmlData.elements("name"))
				$itemName = xmlData.name;
			if (xmlData.elements("description"))
				$description = xmlData.description;
		} // end of function setData
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get itemName():String
		{
			return $itemName;
		} // end of function get itemName
		
		public function get imageName():String
		{
			return $imageName;
		} // end of function get imageName
		
		public function get description():String
		{
			return $description;
		} // end of function get description
		
	} // end of class Item
	
} // enDate of package src.Entities