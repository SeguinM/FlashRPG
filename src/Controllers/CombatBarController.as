package src.Controllers
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import src.Utilities.SpriteSwapper;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  CombatBarController extends MovieClip
	{
		
		// VARIABLES------------------------------------------------------------------------------------------------------
		
		public static const EVENT_ATTACK_CLICKED:String = "onAttackClickedEvent";
		public static const EVENT_ABILITY_CLICKED:String = "onAbilityClickedEvent";
		public static const EVENT_ITEM_CLICKED:String = "onItemClickedEvent";
		public static const EVENT_RUN_CLICKED:String = "onRunClickedEvent";
		
		private var uiPool:Array = [];
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CombatBarController() 
		{
			super();
			init();
		} // end of constructor function
		
		public function populateCharacterData(goodGuys:Array, badGuys:Array):void
		{
			trace ("POPULATING");
			clearAllCharacterData();
			
			populateGoodGuyData(goodGuys);
			populateBadGuyData(badGuys);
		} // end of function populateCharacterData
		
		public function removeItem(id:int):void
		{
			for (var i:int = 0; i < uiPool.length; i++)
			{
				if (uiPool[i].id == id)
				{
					uiPool[i].parent.removeChild(uiPool[i]);
					uiPool.splice(i, 1);
				} // end of nested if loop
			} // end of for loop
		} // end of function removeItem
		
		public function setDecisionButtonVis(state:Boolean):void
		{
			if (!btn_attack) return;
			
			btn_attack.visible = state;
			btn_ability.visible = state;
			btn_item.visible = state;
			btn_escape.visible = state;
		} // end of function setDecisionButtonVis
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			initButtons();
		} // end of function init
		
		private function initButtons():void
		{
			if (!btn_attack) return;
			
			btn_attack.tf.text = "ATTACK";
			btn_ability.tf.text = "ABILITY";
			btn_item.tf.text = "ITEMS";
			btn_escape.tf.text = "RUN";
			
			btn_attack.addEventListener(MouseEvent.CLICK, onAttackClicked);
			btn_ability.addEventListener(MouseEvent.CLICK, onAbilityClicked);
			btn_item.addEventListener(MouseEvent.CLICK, onItemClicked);
			btn_escape.addEventListener(MouseEvent.CLICK, onRunClicked);
		} // end of function initButtons
		
		private function onAttackClicked(event:MouseEvent):void
		{
			trace ("Attack clicked");
			dispatchEvent(new Event(EVENT_ATTACK_CLICKED));
		} // end of function onAttackClicked
		
		private function onAbilityClicked(event:MouseEvent):void
		{
			// DO STUFF
			dispatchEvent(new Event(EVENT_ABILITY_CLICKED));
		} // end of function onAbilityClicked
		
		private function onItemClicked(event:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_ITEM_CLICKED));
		} // end of function onItemClicked
		
		private function onRunClicked(event:MouseEvent):void
		{
			// DO STUFF
			dispatchEvent(new Event(EVENT_RUN_CLICKED));
		} // end of function onRunClicked
		
		private function clearAllCharacterData():void
		{
			uiPool = [];
			
			while (characterUIBar.numChildren > 0)
				characterUIBar.removeChildAt(0);
				
			while (enemyUIBar.numChildren > 0)
				enemyUIBar.removeChildAt(0);
		} // end of function clearAllCharacterData
		
		private function populateGoodGuyData(array:Array):void
		{
			for (var i:int = 0; i < array.length; i++)
			{
				var charUI:MovieClip = SpriteSwapper.getSprite("combatCharUI");
				characterUIBar.addChild(charUI);
				charUI.x = charUI.width * i;
				charUI.setData(array[i]);
				uiPool.push(charUI);
			} // end of for loop
		} // end of function populateGoodGuyData
		
		private function populateBadGuyData(array:Array):void
		{
			for (var i:int = 0; i < array.length; i++)
			{
				var charUI:MovieClip = SpriteSwapper.getSprite("combatCharUI");
				enemyUIBar.addChild(charUI);
				charUI.x = charUI.width * i;
				charUI.setData(array[i]);
				uiPool.push(charUI);
			} // end of for loop
		} // end of function populateBadGuyData
		
	} // end of class CombatBarController
	
} // end of package src.Controllers