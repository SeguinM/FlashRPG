package src.Utilities
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class AnimationUtility extends MovieClip
	{
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function AnimationUtility() { } // constructor function
		
		public static function animateTo(clip:MovieClip, duration:Number, data:Object):void
		{
			var newPosition:Point = new Point(clip.x, clip.y);
			
			if (data.x != null)
				newPositon.x = data.x;
			if (data.y != null)
				newPosition.y = data.y;
				
			
		} // end of function animateTo
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	} // end of class AnimationUtility
	
} // end of package src.Utilities