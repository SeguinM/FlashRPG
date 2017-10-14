package src.Controllers 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import src.Events.EventWithData;
	import src.Utilities.SpriteSwapper;
	
	
	public class DialogueController extends MovieClip 
	{
		
		// VARIABLES-----------------------------------------------------------------------------------------------------
		
		private var dialogueEntryQueue:Array = [];
		
		public static const EVENT_HIDE_REQUEST:String = "hideEventRequest";
		public static const EVENT_RESULT_REQUEST:String = "resultEventRequest";
		public static const EVENT_DIALOGUE_COMPLETE:String = "onDialogueCompleteEvent";
		
		private var resultQueue:Array = [];
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DialogueController() 
		{
			super();
			init();
		} // end of constructor function
		
		public function setDialogue(params:Object):void
		{
			hideCharContainers();
			
			if (params.name != null)
				nameTxt.text = params.name;
				
			if (params.message != null)
				messageTxt.htmlText = params.message;
				
			if (params.character != null)
				setCharContainer((params.side == null ? "left" : params.side), params.character);
		} // end of function setDialogue
		
		public function playDialogueEntry(entry:Array):void
		{
			dialogueEntryQueue = entry;
			
			if (entry == null) return;
			if (entry.length < 1) return;
			
			setData(entry[0]);
			
			dialogueEntryQueue.splice(0, 1);      // removes current entry from queue
		} // end of function playDialogueEntry
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			addEventListener(MouseEvent.CLICK, onDialogueClicked);
		} // end of function init
		
		private function onDialogueClicked(event:MouseEvent):void
		{
			if (dialogueEntryQueue == null) return;
			
			if (dialogueEntryQueue.length > 0)
			{
				
				setData(dialogueEntryQueue[0]);
				dialogueEntryQueue.splice(0, 1);
			} // end of if statement
			
			else if (dialogueEntryQueue.length == 0)
			{
				dispatchEvent(new Event(EVENT_HIDE_REQUEST));
				dispatchEvent(new Event(EVENT_DIALOGUE_COMPLETE));
			} // end of else if statement
		} // end of function onDialogueClicked
		
		private function setData(params:Object):void
		{
			hideCharContainers();
			
			if (params.name != null)
				nameTxt.text = params.name;
				
			if (params.message != null)
				messageTxt.htmlText = params.message;
				
			if (params.image != null)
				setCharContainer((params.side == null ? "left" : params.side), params.image);
				
			if (params.results != null)
			{
				resultQueue = params.results;
				addEventListener(MouseEvent.CLICK, triggerResults);
			} // end of if statement
		} // end of function setData
		
		private function triggerResults(event:MouseEvent):void
		{
			trace ("hit triggerResults");
			removeEventListener(MouseEvent.CLICK, triggerResults);
			
			if (resultQueue.length == 0) return;
			
			dispatchEvent(new EventWithData(EVENT_RESULT_REQUEST, { results:resultQueue } ));
			
			resultQueue = [];
		} // end of function triggerResults
		
		private function hideCharContainers():void
		{
			container_right.visible = false;
			container_left.visible = false;
		} // end of function hideCharContainers
		
		private function setCharContainer(side:String, character:String)
		{
			var containerRef:MovieClip;
			
			if (side == "right")
				containerRef = container_right;
			else
				containerRef = container_left;
				
			// cleans out children
			while (containerRef.numChildren > 0)
				containerRef.removeChildAt(0);
				
			var dialogueImage:MovieClip = SpriteSwapper.getSprite(character);
			
			if (dialogueImage == null) return;
			
			containerRef.addChild(dialogueImage);
			dialogueImage.x = 0;
			dialogueImage.y = 0;
			
			containerRef.visible = true;
		} // end of function setCharContainer
		
	} // end of class DialogueController
	
} // end of package src.Controllers
