package src.Controllers
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.Controllers.WorldMenu.InventoryTabController;
	import src.Controllers.WorldMenu.PartyTabController;
	import src.Entities.Item;
	import src.Events.EventWithData;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE
	 * This serves as base class for all UI elements. 
	 */
	public class  UIControllerBase extends MovieClip
	{	
		
		private var uiElements:Array;
		private var uiContainer:MovieClip;
		
		public static const EVENT_HIDE_REQUEST:String = "hideEventRequest";
		public static const EVENT_RESULT_REQUEST:String = "resultEventRequest";
		public static const EVENT_DIALOGUE_COMPLETE:String = "onDialogueCompleteEvent";
		public static const EVENT_REFRESH_DATA:String = "refreshDataRequestEvent";
		private static const EVENT_REMOVE_ITEM:String = "removeItemEvent";
		
		public var partyController:PartyController;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function UIControllerBase($uiContainer:MovieClip)
		{
			init($uiContainer);
			hideAll();
		} // end of function UIControllerBase
		
		public function show(stringID:String):void
		{
			if (uiElements == null)
				return;
				
			var $element:DisplayObject;
			
			for (var i:int = 0; i < uiElements.length; i++)
			{
				if (uiElements[i].name == stringID)
				{
					$element = uiElements[i];
					break;
				} // end of if statement
			} // end of for loop
			
			// null catch
			if ($element == null)
				return;
				
			$element.visible = true;
		
		} // end of function show
		
		public function hide(stringID:String):void
		{
			if (uiElements == null) return;
			
			var $element:DisplayObject;
			
			for (var i:int = 0; i < uiElements.length; i++)
			{
				if (uiElements[i].name == stringID)
				{
					$element = uiElements[i];
					break;
				} // end of nested if statement
			} // end of for loop
			
			if ($element == null) return;
			
			$element.visible = false;
		} // end of function hide
		
		public function hideAll():void
		{
			if (uiElements == null) return;
			
			for (var i:int = 0; i < uiElements.length; i++)
			{
				uiElements[i].visible = false;
			} // end of for loop
		} // end of function hideAll
		
		public function getUIElement(elementName:String):MovieClip
		{
			trace ("Getting UI element... " + elementName + " " + uiElements.length);
			
			var ret:MovieClip;
			
			for (var i:int = 0; i < uiElements.length; i++)
			{
				trace ("element " + i + " is " + uiElements[i].name);
				if ((uiElements[i] as MovieClip).name == elementName)
				{
					trace ("found it!");
					ret = uiElements[i] as MovieClip;
					break;
				} // end of if statement
			} // end of for loop
			
			return ret;
		} // end of function getUIElement
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($uiContainer:MovieClip):void
		{
			uiContainer = $uiContainer;
			getUIElements();
			setListeners();
		} // end of init
		
		private function getUIElements():void
		{
			if (uiElements == null)
				uiElements = [];
				
			for (var i:int = 0; i < uiContainer.numChildren; i++)
				uiElements.push(uiContainer.getChildAt(i));
		} // end of function getUIElements
		
		private function setListeners():void
		{
			for (var i:int = 0; i < uiElements.length; i++)
			{
				uiElements[i].addEventListener(EVENT_HIDE_REQUEST, onUIElementHideRequest);
				
				if (uiElements[i].name == "dialogue")
				{
					uiElements[i].addEventListener(EVENT_RESULT_REQUEST, onResultsRequested);
					uiElements[i].addEventListener(EVENT_DIALOGUE_COMPLETE, onDialogueCompleted);
				} // end of if statement
				
				if (uiElements[i].name == "worldMenu")
				{
					uiElements[i].addEventListener(EVENT_REMOVE_ITEM, onRemoveItemRequest);
					uiElements[i].addEventListener(EVENT_REFRESH_DATA, onDataRefreshRequested);
				} // end of if statement
			} // end of for loop
				
		} // end of function getListeners
		
		private function onUIElementHideRequest(event:Event):void
		{	// called when a UI Element requests itself to be hidden via a request event.
			var elementName:String = (event.target as DisplayObject).name;
			
			hide(elementName);
		} // end of function onUIElementHideRequest
		
		private function onRemoveItemRequest(event:EventWithData):void
		{
			var item:Item = event.data.item;
			if (item == null) return;
			partyController.removeInventoryItem(item);
		} // end of function onRemoveItemRequest
		
		private function onResultsRequested(event:EventWithData):void
		{	// called when the last dialogue is clicked in a sequence and there are results
			// send up the chain to Main.
			if (event.data.results != null)
				dispatchEvent(new EventWithData(EVENT_RESULT_REQUEST, event.data));
		} // end of function onResultsRequested
		
		private function onDialogueCompleted(event:Event):void
		{	// Triggered by event when dialogue finishes
			dispatchEvent(new Event(EVENT_DIALOGUE_COMPLETE));
		} // end of function onDialogueCompleted
		
		private function onDataRefreshRequested(event:EventWithData):void
		{	// Pushed up from WorldController::Tab Controller
			trace ("UIControllerBase::onDataRefreshRequested");
			
			var tabController:*;
			
			tabController = event.data.controller;
			
			trace ("tabController type: " + tabController);
			
			if (tabController != null)
				populateMenuTab(tabController);
			
		} // end of function onDataRefreshRequested
		
		private function populateMenuTab(controller:*):void
		{
			if (controller is PartyTabController && partyController != null)
				controller.populate( { characters: partyController.activeParty } );
			if (controller is InventoryTabController && partyController != null)
				controller.populate( { weapons: partyController.weapons, items: partyController.items, characters: partyController.activeParty } );
		} // end of function populateMenuTab
		
	} // end of class UIControllerBase
	
} // enDate of package src.Controllers