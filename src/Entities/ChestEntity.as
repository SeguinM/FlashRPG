package src.Entities 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import src.Events.EventWithData;
	
	
	public class ChestEntity extends MovieClip 
	{
		private var $inventory:Array = [];
		private var $money:int = 0;
		
		public static const EVENT_ADD_INVENTORY:String = "onAddInventoryEvent";
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function ChestEntity() 
		{
			super();
			init();
			// constructor code
		} // end of constructor function
		
		public function setData(params:Object):void
		{
			trace("ChestEntity::setData");
			
			if (params.items != null)
				generateItems(params.items);
			if (params.weapons != null)
				generateWeapons(params.weapons);
			if (params.money != null)
				generateMoney(params.money);
		} // end of function setData
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK, onEntityClicked);
		} // end of function init
		
		private function onEntityClicked(event:MouseEvent):void
		{
			trace ("Chest! " + $inventory);
			dispatchEvent(new EventWithData(EVENT_ADD_INVENTORY, { inventory: $inventory }, true ));
			$inventory = [];
		} // end of function onEntityClicked
		
		private function generateItems(array:Array):void
		{
			for (var i:int = 0; i < array.length; i++)
			{
				var newItem:Item = new Item(array[i]);
				$inventory.push(newItem);
			} // end of for loop
		} // end of function generateItems
		
		private function generateWeapons(array:Array):void
		{
			for (var i:int = 0; i < array.length; i++)
			{
				var newWeapon:Weapon = new Weapon(array[i]);
				$inventory.push(newWeapon);
			} // end of for loop
		} // end of function generateWeapons
		
		private function generateMoney(value:int):void
		{
			$money = value;
		} // end of function generateMoney
		
	} // end of class ChestEntity
	
} // end of package src.Entities
