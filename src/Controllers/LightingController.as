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
	public class  LightingController extends MovieClip
	{
		
		// VARIABLES
		private var stageRef:Stage;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function LightingController($stageRef:Stage)
		{
			init($stageRef);
		} // end of constructor function
		
		public function setAmbientLight(lightColor:uint, $container:MovieClip, params:Object):void
		{	// SETS AMBIENT LIGHT ON SPECIFIED OBJECTS
			// null check
			if ($container == null)
				return;
				
			// checks to see if lighting overlay already exists
			if ($container.getChildByName("lightOverlay"))
				$container.removeChild($container.lightOverlay);
				
			var light:Shape = new Shape();
			light.graphics.beginFill(lightColor);
			light.graphics.drawRect(0, 0, $container.width, $container.height);
			light.graphics.endFill();
			$container.addChild(light);
			$container.setChildIndex(light, $container.numChildren - 1);
			light.name = "lightOverlay";

			// Sets blendmode
			if (params.blendMode != null)
				light.blendMode = params.blendMode;
				
			else
				light.blendMode = "screen";
				
			// opacity
			if (params.alpha != null)
				light.alpha = params.alpha;
			
		} // end of function setAmbientLight
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($stageRef:Stage):void
		{
			stageRef = $stageRef;
		} // end of function init
		
	} // end of class LightingController
	
} // end of package src.Controllers