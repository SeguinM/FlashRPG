package src.Controllers.WorldMenu
{
	import fl.motion.MotionEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import src.Controllers.CombatCharacterDataUI;
	import src.Entities.Character;
	import src.Entities.Item;
	import src.Events.EventWithData;
	import src.Utilities.SpriteSwapper;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  InventoryTabController extends TabBase
	{
		
		private var inv_weapons:Array = [];
		private var inv_items:Array = [];
		
		private var queuedCharacter:Character;
		private var queuedItem:Item;
		
		private var elements:Array = [];
		private var charElements:Array = [];
		
		private static const EVENT_REMOVE_ITEM:String = "removeItemEvent";
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function InventoryTabController(clip:MovieClip)
		{
			super(clip);
			init();
		} // end of constructor function
		
		override public function refresh():void
		{
			super.refresh();
			this.dispatchEvent(new EventWithData(EVENT_REFRESH_DATA, { controller: this } ));
		} // end of function refresh
		
		public function populate(params:Object):void
		{	// fills list with data
			
			// clears out any children in list
			removeAll();
			
			if (params.weapons != null)
				addWeapons(params.weapons);
			if (params.items != null)
				addItems(params.items);
			if (params.characters != null)
				generateCharacterData(params.characters);
			generateDisplayData();
		} // end of function populate
		
		override public function removeAll():void
		{
			while (content.numChildren > 0)
				content.removeChildAt(0);
				
			while (party.numChildren > 0)
				party.removeChildAt(0);
				
			inv_items = [];
			inv_weapons = [];
			elements = [];
			charElements = [];
			
			queuedCharacter = null;
			queuedItem = null;
		} // end of function removeAll
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			mouseChildren = true;
			clip.tab.txt.text = "INVENTORY";
			initConfirmUsePopup();
		} // end of function init
		
		private function initConfirmUsePopup():void
		{
			var popup:MovieClip = clip.getChildByName("confirmUse") as MovieClip;
			
			if (popup == null) return;
			
			popup.messageTxt.text = "Use item on this character?";
			popup.btn_yes.txt.text = "YES";
			popup.btn_no.txt.text = "NO";
			
			popup.btn_yes.addEventListener(MouseEvent.CLICK, onYesClicked);
			popup.btn_no.addEventListener(MouseEvent.CLICK, onNoClicked);
			
			(clip.getChildByName("confirmUse") as MovieClip).visible = false;
		} // end of function initConfirmUsePopup
		
		private function addItems(inv:Array):void
		{
			for (var i:int = 0; i < inv.length; i++)
				inv_items.push(inv[i]);
		} // end of function addItems
		
		private function addWeapons(inv:Array):void
		{
			for (var i:int = 0; i < inv.length; i++)
				inv_weapons.push(inv[i]);
		} // end of function addWeapons
		
		private function generateCharacterData(characters:Array):void
		{
			trace ("InventoryTabController::generateCharacterData");

			if (characters == null) return;
			if (characters.length == 0) return;

			for (var i:int = 0; i < characters.length; i++)
			{
				var newElement:MovieClip = SpriteSwapper.getSprite("PartyDataItemUI");
				party.addChild(newElement);
				newElement.x = 0;
				newElement.y = i * newElement.height;
				newElement.setData(characters[i]);
				newElement.mouseEnabled = true;
				newElement.mouseChildren = false;
				charElements.push(newElement);
				newElement.name = "CharElement" + String(i);
				newElement.addEventListener(MouseEvent.CLICK, onCharacterClicked);
				//characters.push(newElement);
			} // end of for loop
		} // end of function generateCharacterData
		
		private function generateDisplayData():void
		{
			// Lets default this to just usable items for now
			for (var i:int = 0; i < inv_items.length; i++)
			{
				var item:MovieClip = SpriteSwapper.getSprite("InventoryItemUI");
				if (item == null) return;
				
				item.txt.text = (inv_items[i] as Item).itemName;
				item.item = (inv_items[i] as Item);
				item.mouseChildren = false;
				content.addChild(item);
				item.y = item.height * i;
				item.addEventListener(MouseEvent.CLICK, onItemClicked);
				elements.push(item);
			} // end of for loop
			
			setDefaultItem();
		} // end of function generateDisplayData
		
		private function setDefaultItem():void
		{
			trace ("Setting default item");
			var item:MovieClip = elements[0];
			
			for (var i:int = 0; i < elements.length; i++)
				elements[i].gotoAndStop("off");
			item.gotoAndStop("on");
			setDetails(item.item);
		} // end of function setDefaultItem
		
		private function onItemClicked(event:MouseEvent):void
		{
			var item:MovieClip = event.target as MovieClip;
			if (item == null) return;
			
			for (var i:int = 0; i < elements.length; i++)
				elements[i].gotoAndStop("off");
			item.gotoAndStop("on");
			
			setDetails(item.item);
		} // end of function onItemClicked
		
		private function setDetails(item:Item):void
		{
			if (item == null) return;
			
			// sets as queued item
			queuedItem = item;
			
			while (image.numChildren > 0)
				image.removeChildAt(0);
				
			var newImg:MovieClip = SpriteSwapper.getSprite(item.imageName);
			image.addChild(newImg);
			newImg.x = 0;
			newImg.y = 0;
			
			titleTxt.text = item.itemName;
			descriptionTxt.text = item.description;
		} // end of function setDetails
		
		private function onCharacterClicked(event:MouseEvent):void
		{
			
			for (var i:int = 0; i < charElements.length; i++)
			{
				if (charElements[i].name == (event.target as MovieClip).name)
				{
					queuedCharacter = charElements[i].getCharacter();
					trace ("CHARACTER CLICKED: " + queuedCharacter + " " + event.target);
					(clip.getChildByName("confirmUse") as MovieClip).visible = true;
				} // end of if statement
			} // end of for loop
			
			//if (queuedCharacter == null) return;
			
		} // end of function onCharacterClicked
		
		private function onYesClicked(event:MouseEvent):void
		{
			(clip.getChildByName("confirmUse") as MovieClip).visible = false;
			useActiveItem();
			queuedCharacter = null;
		} // end of function onYesClicked
		
		private function onNoClicked(event:MouseEvent):void
		{
			(clip.getChildByName("confirmUse") as MovieClip).visible = false;
			queuedCharacter = null;
		} // end of function onNoClicked
		
		private function useActiveItem():void
		{
			trace ("item used!");
			queuedItem.useItem( { defender: queuedCharacter } );
			
			// removes item from pool
			this.dispatchEvent(new EventWithData(EVENT_REMOVE_ITEM, { item: queuedItem } ));
			
			queuedItem = null;
			queuedCharacter = null;
			this.dispatchEvent(new EventWithData(EVENT_REFRESH_DATA, { controller: this } ));
			setDefaultItem();
		} // end of function useActiveItem
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function get content():MovieClip
		{
			return clip.getChildByName("content") as MovieClip;
		} // end of function get content
		
		private function get party():MovieClip
		{
			return clip.getChildByName("partyData") as MovieClip;
		} // end of function get party
		
		private function get image():MovieClip
		{
			return clip.getChildByName("image") as MovieClip;
		} // end of function get image
		
		private function get titleTxt():TextField
		{
			return clip.getChildByName("titleTxt") as TextField;
		} // end of function get titleTxt
		
		private function get descriptionTxt():TextField
		{
			return clip.getChildByName("descriptionTxt") as TextField;
		} // end of function get descriptionTxt
		
	} // end of class TabBase
	
} // end of package TabBase