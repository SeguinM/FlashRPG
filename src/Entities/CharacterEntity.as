package src.Entities 
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import src.Controllers.WorldController;
	import src.Events.EventWithData;
	import src.Utilities.DialogueUtility;
	
	
	public class CharacterEntity extends MovieClip 
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var internalCharacter:Character;     // assigned from params in setData
		
		public static const EVENT_CHARACTER_ENTITY_CLICKED:String = "CharacterEntityClickedEvent";
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CharacterEntity() 
		{
			super();
			init();
		} // end of constructor function
		
		public function setData(params:Object):void
		{
			/* TO DO:
				 * generate character and spawn asset
				 * parse interaction type and create dialogue parser and flow
			*/
			trace ("CharacterEntity::setData");
			
			if (params.character != null)
			{
				internalCharacter = params.character;
				spawnCharacter(params.character, params.anim != null ? params.anim : "idle_right");
			} // end of if statement
				
			trace ("Interaction data: " + params.interactionType + " " + params.interactionID);
			if (params.interactionType != null && params.interactionID != null)
				setInitialInteraction(params.interactionType, params.interactionID);
				
			/*if (params.worldController != null)
				$worldController = params.worldController;
			if (params.playerController != null)
				$playerController = params.playerController;*/
		} // end of function setData
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			addEventListener(MouseEvent.CLICK, onEntityClicked);
		} // end of function init
		
		private function spawnCharacter(character:Character, animState:String):void
		{
			if (characterContainer == null) return;
			
			while (characterContainer.numChildren > 0)
				characterContainer.removeChildAt(0);
				
			characterContainer.addChild(character);
			
			character.x = 0;
			character.y = 0;
			
			character.setAnimState(animState);
		} // end of function createNewCharacter
		
		private function setInitialInteraction(type:String, value:String):void
		{
			switch(type)
			{
				case "dialogue":
					internalCharacter.addDialogueEntry(DialogueUtility.getDialogueEntry(value));
					break;
			} // end of type
		} // end of function setInitialInteraction
		
		private function onEntityClicked(event:MouseEvent):void
		{
			if (internalCharacter == null) return;
			// tried hooking up the controllers to this class through set data, but it was having a fit... so fuck it. Let's bubble an event up the chain which should link back to the character's interact function.
			dispatchEvent(new EventWithData(EVENT_CHARACTER_ENTITY_CLICKED, { character:internalCharacter }, true ));
			trace ("detecting entity click.");
			// debug
			//internalCharacter.interact();
		} // end of function onEntityClicked
		
	} // end of class CharacterEntity
	
} //end of package src.Entities
