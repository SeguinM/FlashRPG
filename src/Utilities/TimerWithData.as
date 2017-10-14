package src.Utilities
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class TimerWithData extends MovieClip 
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var internalData:Object;
		private var internalTimer:Timer;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function TimerWithData(duration:Number, data:Object)
		{
			internalData = data;
			
			var timer:Timer;
			timer = new Timer(duration * 1000, (data.repeatCount != null ? data.repeatCount : 1));
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete)
			internalTimer = timer;
		} // end of function TimerWithData
		
		public function startTimer():void
		{
			internalTimer.start();
		} // end of function startTimer
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onTimerComplete(event:TimerEvent):void
		{
			trace ("TIMER COMPLETED. ");
			if (internalData == null) return;
			
			if (internalData.onComplete != null)
			{
				var completeFunction:Function = internalData.onComplete;
				
				if (internalData.onCompleteParams != null)
					completeFunction(internalData.onCompleteParams);
				else
					completeFunction();
			} // end of if statement
		} // end of function onTimerComplete
		
	} // end of class TimerWithData
	
} // end of package src.Utilities