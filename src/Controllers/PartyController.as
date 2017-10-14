package src.Controllers
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import src.Entities.Character;
	import src.Entities.Item;
	import src.Entities.Weapon;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE: This class controls the player's battle party, which includes not only active battle party characters, 
	 * but inactive and ones assigned to other ops.
	 */
	public class  PartyController extends MovieClip
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var stageRef:Stage;                                    // reference to stage
		private var party_active:Array;                                // player's active battle party
		private var party_inactive:Array;                              // inactive or otherwise unassigned party members
		
		private var inv_weapons:Array = [];                            // weapon inventory
		private var inv_items:Array = [];                              // item inventory
		
		public var characterDataManager:CharacterDataManager;          // character data manager
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function PartyController($stageRef:Stage)
		{
			init($stageRef);
		} // end of function PartyController
		
		public function addItem(type:String, character:Character):void
		{
			var array:Array = getArrayType(type);
			
			if (array == null)
				array = [];
				
			array.push(character);

		} // end of function addItem
		
		public function updateItem(type:String, character:Character):void
		{
			// DO STUFF
		} // // end of function updateItem
		
		public function removeItem(type:String, character:Character):void
		{
			// DO STUFF
		} // end of function removeItem
		
		public function removeAll(type:String = "all"):void
		{
			if (type == "all")
			{
				party_active = [];
				party_inactive = [];
			} // end of if statement
			
			else
			{
				var array:Array = getArrayType(type);
				array = [];
			} // end of else statement
		} // end of function removeAll
		
		public function startNewGame():void
		{
			if (characterDataManager == null) return;
			
			removeAll();
			
			// generates default Luigi character
			generateDefaultCharacter();
			
			// generates default inventory
			generateDefaultInventory();
			
		} // end of function startNewGame
		
		public function addInventory(inv:Array):void
		{	// adds new inventory. Items, weapons
			while (inv.length > 0)
			{
				if (inv[0] is Item)
					inv_items.push(inv[0]);
				else if (inv[0] is Weapon)
					inv_weapons.push(inv[0]);
				else
					trace ("WARNING: invalid inventory added at PartyController::addInventory. " + inv[0] + " Inventory item has been discarded.");
					
				// removes from queue
				inv.splice(0, 1);
			} // end of while loop
		} // end of function addInventory
		
		public function removeInventoryItem(item:Item):void
		{
			for (var i:int = 0; i < inv_items.length; i++)
			{
				if (inv_items[i] == item)
				{
					inv_items.splice(i, 1);
					break;
				} // end of if statement
			} // end of for loop
		} // end of function removeInventoryItem
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($stageRef:Stage):void
		{
			stageRef = $stageRef;
		} // end of function init
		
		private function generateDefaultCharacter():void
		{
			var char:Character = characterDataManager.generateNewCharacter("Luigi", 5) as Character;
			
			addItem("active", char);
		} // end of function generateDefaultCharacter
		
		private function generateDefaultInventory():void
		{
			for (var i:int = 0; i < 3; i++)
			{
				var item:Item = new Item("Mushroom");
				inv_items.push(item);
			} // end of for loop
		} // end of function generateDefaultInventory
		
		private function getArrayType(type:String):Array
		{
			var ret:Array;
			
			switch(type)
			{
				case "active":
					ret = party_active;
					break;
				case "inactive":
					ret = party_inactive;
					break;
				default:
					throw new Error("Invalid type given at PartyController::getArrayType.");
					break;
			} // end of switch
			
			return ret;
		} // end of function getArrayType
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get activeParty():Array
		{
			return party_active;
		} // end of function get activeParty
		
		public function get items():Array
		{
			return inv_items;
		} // end of function get items
		
		public function get weapons():Array
		{
			return inv_weapons;
		} // end of function get weapons
		
		
	} // end of class PartyController
	
} // end of package src.Controllers