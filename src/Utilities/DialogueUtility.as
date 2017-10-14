package src.Utilities
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  DialogueUtility extends MovieClip
	{
		
		// EXTERNALLY ASSIGNED VARS----------------------------------------------------------------------------------------
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DialogueUtility() { } // Constructor function
		
		public static function getDialogueEntry(value:String):Array
		{
			var entry:Array;
			
			var dialogueXML:XML = XMLLoader.getLoadedXML("DialogueList");
			
			if (dialogueXML == null) return null; // null check
			
			trace ("POST DIALOGUE XML LOAD");
			
			var dialogueInstanceXML:XML;         // temporary var for the single dialogue XML instance we need
			var dialogueXMLList:XMLList;            // Array that stores all found 'dialogue' elements
			
			dialogueXMLList = dialogueXML.dialogue;      // Looks weird, but assigns all instances of 'dialogue' elements to this array
			
			for each (var $tag:XML in dialogueXMLList)
			{
				if ($tag.attribute("id"))
				{
					if ($tag.@id == value)
						entry = parseDialogueArray($tag);
				} // end of if statement
			} // end of for each loop
			
			return entry;
		} // end of function getDialogueEntry
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function parseDialogueArray($tag:XML):Array
		{
			var entry:Array = [];
			var entryList:XMLList = $tag.entry;     // assigns all instances of entry to entryList
			
			for each (var xmlData:XML in entryList)
			{
				var dialogueDataObject:Object = { };
				
				if (xmlData.attribute("side"))
					dialogueDataObject.side = xmlData.@side;
				if (xmlData.attribute("image"))
					dialogueDataObject.image = xmlData.@image;
				if (xmlData.attribute("name"))
					dialogueDataObject.name = xmlData.@name;
				dialogueDataObject.message = String(xmlData);

				entry.push(dialogueDataObject);
			} // end of for each loop
			
			// adds result data to last dialogue entry
			var results:Array = [];
			var resultList:XMLList = $tag.result;       // assigns all instances of result
			
			for each (var resultXML:XML in resultList)
			{
				var resultDataObject:Object = { };
				
				if (resultXML.attribute("type"))
					resultDataObject.type = resultXML.@type;
				if (resultXML.attribute("value"))
					resultDataObject.value = resultXML.@value;
				if (resultXML.attribute("level"))
					resultDataObject.level = parseInt(resultXML.@level);
				if (resultXML.attribute("weapon"))
					resultDataObject.weapon = resultXML.@weapon;
				if (resultXML.elements("enemy"))
				{
					var xmlList:XMLList = resultXML.enemy;
					var arr:Array = generateEnemyArray(xmlList);
					resultDataObject.enemies = arr;
				} // end of if statement
					
				results.push(resultDataObject);
			} // end of for each loop
			
			// sets result array data only if larger than 0 results
			if (results.length > 0)
				entry[entry.length - 1].results = results;
			
			return entry;
		} // end of static function parseDialogueArray
		
		private static function generateEnemyArray(arr:XMLList):Array
		{
			//trace ("\n\n\n\n\n\n\nGenerate enemies! " + arr);
			var ret:Array = [];
			
			for each (var $tag:XML in arr)
			{
				var enemyDataObject:Object = { };
				
				if ($tag.attribute("id"))
					enemyDataObject.id = $tag.@id;
				if ($tag.attribute("lvl"))
					enemyDataObject.level = parseInt($tag.@lvl);
					
				ret.push(enemyDataObject);
			} // end of for each loop
			
			return ret;
		} // end of function generateEnemyArray
		
	} // end of class DialogueUtility
	
} // end of package src.Utilities