package src.Utilities
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE:
	 * Provides a variety of manipulation utilities such as tweening, coloring, etc
	 */
	public class  ManipulationUtility extends MovieClip
	{
		
		public function ManipulationUtility()
		{
			// Do nothing, as this is a static class
		} // end of ManipulationUtility
		
		public static function animateTo(clip:MovieClip, duration:Number, params:Object)
		{
			var currentPos:Point = new Point();
			var currentAlpha:Number = clip.alpha;
			currentPos.x = clip.x;
			currentPos.y = clip.y;
			
			
		} // end of function animateTo
		
	} // end of class ManipulationUtility
	
} // end of package src.Utilities