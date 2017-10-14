package src.Controllers 
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.sampler.NewObjectSample;
	import src.Controllers.WorldMenu.InventoryTabController;
	import src.Controllers.WorldMenu.PartyTabController;
	import src.Controllers.WorldMenu.QuestsTabController;
	import src.Entities.Item;
	import src.Events.EventWithData;
	
	
	public class WorldMenuController extends MovieClip 
	{
		
		// VARIABLES------------------------------------------------------------------------------------------------------
		
		public static const EVENT_REFRESH_DATA:String = "refreshDataRequestEvent";
		private static const EVENT_REMOVE_ITEM:String = "removeItemEvent";
		
		private var tabs:Array = [];             // movie clips
		private var controllers:Array = [];      // controllers
		
		private var partyTabController:PartyTabController;
		private var questsTabController:QuestsTabController;
		private var inventoryTabController:InventoryTabController;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function WorldMenuController() 
		{
			super();
			init();
		} // end of constructor function
		
		public function refresh():void
		{	
			trace ("WorldMenuController::refresh");
			
			for (var i:int = 0; i < tabs.length; i++)
				controllers[i].refresh();
		} // end of function refresh
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			tabs = [party, quests, inventory];
			
			initTabs();
		} // end of function init
		
		private function initTabs():void
		{
			for (var i:int = 0; i < tabs.length; i++)
			{
				//tabs[i].mouseChildren = false;
				tabs[i].addEventListener(MouseEvent.CLICK, onTabSelect);
			} // end of for loop
			
			partyTabController = new PartyTabController(party);
			questsTabController = new QuestsTabController(quests);
			inventoryTabController = new InventoryTabController(inventory);
			
			controllers = [partyTabController, questsTabController, inventoryTabController];
			
			for (var j:int = 0; j < controllers.length; j++)
			{
				controllers[j].addEventListener(EVENT_REFRESH_DATA, onDataRefreshRequested);
			} // end of for loop
			
			inventoryTabController.addEventListener(EVENT_REMOVE_ITEM, onRemoveItemRequest);
		} // end of function initTabs
		
		private function onTabSelect(event:MouseEvent):void
		{
			if (event.target.name != "quests" && event.target.name != "inventory" && event.target.name != "party")
				return;
				
			var clip:DisplayObject = event.target as DisplayObject;
			
			setChildIndex(clip, numChildren - 1);
		} // end of function onTabSelect
		
		private function onDataRefreshRequested(event:EventWithData):void
		{	// push up to UIControllerBase
			trace ("WorldMenuController::onDataRefreshRequested");
			
			// seems to have issues just passing event, so wrapping it in a new event
			var ctrl:* = event.data.controller;
			if (ctrl == null) return;
			this.dispatchEvent(new EventWithData(EVENT_REFRESH_DATA, { controller: ctrl }));
		} // end of function onDataRefreshRequested
		
		private function onRemoveItemRequest(event:EventWithData):void
		{
			var item:Item = event.data.item;
			if (item === null) return;
			this.dispatchEvent(new EventWithData(EVENT_REMOVE_ITEM, { item: item } ));
		} // end of function onRemoveItemRequest
		
	} // end of class WorldMenuController
	
} // end of package src.Controllers
