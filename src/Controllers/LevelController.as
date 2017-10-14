package src.Controllers
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import src.Utilities.SpriteSwapper;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  LevelController extends MovieClip
	{
		
		// VARIABLES
		private var stageRef:Stage;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function LevelController($stageRef:Stage)
		{
			init($stageRef);
		} // end of function LevelController
		
		public function loadBG($asset:String, stretchToSize:Boolean = false):void
		{
			var bg:MovieClip;
			bg = SpriteSwapper.getSprite($asset);
			
			// null check
			if (bg == null)
				return;
				
			stageRef.addChild(bg);
			stageRef.setChildIndex(bg, 0);
			
			bg.x = 0;
			bg.y = 0;
			
			if (stretchToSize)
			{
				bg.width = stageRef.stageWidth;
				bg.height = stageRef.stageHeight;
				trace ("Stage dimensions: " + stageRef.stageWidth + ", " + stageRef.stageHeight);
			} // end of stretchToSize
		} // end of function loadBG
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($stageRef:Stage):void
		{
			stageRef = $stageRef;
		} // end of function init
		
	} // end of class LevelController
	
} // enDate of package src.Controllers