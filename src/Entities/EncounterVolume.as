package src.Entities
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.Controllers.CombatController;
	import src.Controllers.PlayerController;
	import src.Events.EventWithData;
	import src.Utilities.LevelLoader;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  EncounterVolume extends MovieClip
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var $isActive:Boolean = false;
		private var encounterRate:Number = 0;                                // Percent chance on a given frame for encounter
		private var enemySets:Array = [];                                    // possible enemy sets (array of Objects)
		
		public static const EVENT_TRIGGER_COMBAT:String = "triggerCombatEvent";
		
		// EXTERNALLY ASSIGNED---------------------------------------------------------------------------------------------
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function EncounterVolume()
		{
			super();
			init();
		} // end of constructor function
		
		public function setData(params:Object):void
		{
			if (params.enemyList != null)
				setEnemyList(params.enemyList);
				
			if (params.encounterRate != null)
				encounterRate = params.encounterRate;
		} // end of function setData
		
		public function onVolumeQuery():void
		{	// RUN ONCE PER FRAME -- only while moving
			var r:Number = Math.random() * 100.00;
			//trace ("NUMBER! " + r + ", RATE: " + encounterRate);
			
			if (r <= encounterRate)
				triggerCombatEncounter();
				
		} // end of function onCollisionFrameTick
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			hideAllChildren();
			mouseEnabled = false;
			mouseChildren = false;
		} // end of function init
		
		private function hideAllChildren():void
		{	// turns all children invisible
			for (var i:int = 0; i < numChildren; i++)
				getChildAt(i).alpha = 0;
		} // end of function hideAllChildren
		
		private function setEnemyList(list:Array):void
		{
			enemySets = list;
		} // end of function setEnemyList
		
		private function triggerCombatEncounter():void
		{
			trace ("COMBAT ENCOUNTER TRIGGERED");
			/*if (LevelLoader.combatController != null)
				LevelLoader.combatController.triggerCombatEncounter(enemySets);*/
				
			//dispatchEvent(new Event(EVENT_TRIGGER_COMBAT, true));
			dispatchEvent(new EventWithData(EVENT_TRIGGER_COMBAT, { enemies:enemySets }, true, false ));
		} // end of function triggerCombatEncounter
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get isActive():Boolean
		{
			return $isActive;
		} // end of function get isActive
		
		public function set isActive(state:Boolean):void
		{
			$isActive = state;
		} // end of function set isActive
		
	} // end of class EncounterVolumeController
	
} // end of package src.Controllers