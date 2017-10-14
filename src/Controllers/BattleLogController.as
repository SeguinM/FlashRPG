package src.Controllers {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.Utilities.SpriteSwapper;
	import src.Utilities.TimerWithData;
	
	
	public class BattleLogController extends MovieClip 
	{	
		
		// VARIABLES------------------------------------------------------------------------------------------------------
		
		private var logQueue:Array = [];               // array of queued battlereport items
		private var isCoolingDown:Boolean = false;     // timeout boolean. set to true if log is still in cooldown from previous log generation.
		
		// CONSTS---------------------------------------------------------------------------------------------------------
		
		private static const TIMER_COOLDOWN:Number = 0.3; // cooldown time between report generations
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function BattleLogController() 
		{
			super();
			init();
		} // end of constructor function
		
		public function generateLog(str:String):void
		{	
			logQueue.push(str);
			
			if (!isCoolingDown)
				spawnLog();
		} // end of function generateLog
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			// DO STUFF
		} // end of function init
		
		private function spawnLog():void
		{
			// null and length check
			if (logQueue == null) return;
			if (logQueue.length < 1) return;
			
			var log:MovieClip = SpriteSwapper.getSprite("BattleLogItem");
			
			if (log == null) return;
			
			trace ("generating log!");
			
			log.txtContainer.txt.text = logQueue[0];
			logQueue.splice(0, 1);    // removes the element at [0]
			
			isCoolingDown = true;
			
			this.addChild(log);
			log.x = 0;
			log.y = 0;
			log.gotoAndPlay(1);
			log.addEventListener(Event.ENTER_FRAME, onLogFrameTick);
			
			var timer:TimerWithData = new TimerWithData(TIMER_COOLDOWN, { onComplete: onLogCooldownComplete } );
			timer.startTimer();
		} // end of function spawnLog
		
		private function onLogFrameTick(event:Event):void
		{	// RUN ONCE PER FRAME
			if ((event.target as MovieClip).currentFrame == (event.target as MovieClip).totalFrames)
			{
				trace ("deleting log");
				event.target.removeEventListener(Event.ENTER_FRAME, onLogFrameTick);
				this.removeChild(event.target as MovieClip);
			} // end of if statement
		} // end of function onLogFrameTick
		
		private function onLogCooldownComplete():void
		{
			if (logQueue.length > 0)
				spawnLog();
			else
				isCoolingDown = false;
		} // end of function onLogComplete
	}
	
}
