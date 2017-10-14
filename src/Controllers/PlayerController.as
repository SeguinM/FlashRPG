package src.Controllers
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import src.Entities.EncounterVolume;
	import src.Entities.Wall;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  PlayerController extends MovieClip
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var stageRef:Stage;                              // references flash stage
		private var keys:Array = [];                             // active keys
		private var $playerGraphic:MovieClip;                     // world mode player graphic
		private var worldRef:MovieClip;                          // world container
		
		private var $isMovable:Boolean = false;                    // Is player movable? In world with no effects?
		
		private var currentAnim:String = "none";
		
		private static const MOVEMENT_SPEED:Number = 5;           // player movement speed. Move this into an external file later
		
		// externally assigned controllers
		public var worldController:WorldController;
		public var uiController:UIControllerBase;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function PlayerController($stageRef:Stage, $worldRef:MovieClip)
		{
			super();
			init($stageRef, $worldRef);
		} // end of constructor function
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($stageRef:Stage, $worldRef:MovieClip):void
		{
			// assigns stage ref
			stageRef = $stageRef;
			worldRef = $worldRef;
			
			initKeyListeners();
			
			// adds listener for update function
			if (stageRef != null)
				stageRef.addEventListener(Event.ENTER_FRAME, update);
		} // end of function init
		
		private function update(event:Event):void
		{	// RUN ONCE PER FRAME
			checkKeyInput();
		} // end of function update
		
		private function checkKeyInput():void
		{	// RUN ONCE PER FRAME
			//trace ("checking key input. " + keys[Keyboard.S] + ", " + $playerGraphic);
			if (keys[Keyboard.S] == true && $playerGraphic != null)
				movePlayer("down");
				
			else if (keys[Keyboard.W] == true && $playerGraphic != null)
				movePlayer("up");
				
			else if (keys[Keyboard.A] == true && $playerGraphic != null)
				movePlayer("left");
				
			else if (keys[Keyboard.D] == true && $playerGraphic != null)
				movePlayer("right");
				
			else if (keys[Keyboard.D] != true && keys[Keyboard.W] != true && keys[Keyboard.A] != true && keys[Keyboard.S] != true)
				movePlayer("none");
		} // end of function checkKeyInput
		
		private function initKeyListeners():void
		{	// adds listeners for keys down and up
			if (stageRef == null) return;
			
			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		} // end of function initKeyListeners
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			keys[event.keyCode] = true;
			//trace ("KEYS: " + keys);
			
			// toggle keys
			switch(event.keyCode)
			{
				case Keyboard.Q:
					if (worldController == null) break;
					if (worldController.gameState != "overworld") break;
					//if (isMovable == false) break;
					
					// at this point, show menu
					toggleWorldMenu();
					break;
			} // end of switch
		} // end of function onKeyDown
		
		private function toggleWorldMenu():void
		{
			trace ("Toggle World Menu");
			var worldUI:MovieClip = uiController.getUIElement("worldMenu");
			
			if (worldUI == null) return;
			
			switch(worldUI.visible)
			{
				case true:
					uiController.hide("worldMenu");
					isMovable = true;
					break;
				case false:
					isMovable = false;
					uiController.show("worldMenu");
					worldUI.refresh();
					break;
			} // end of switch
		} // end of function toggleWorldMenu
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			keys[event.keyCode] = false;
		} // end of function onKeyUp
		
		private function movePlayer(direction:String):void
		{
			if (!$isMovable || $playerGraphic == null) return;
			
			var newPos:Point = new Point($playerGraphic.x, $playerGraphic.y);    // new position of player. Defaults to graphic's current position
			var newWorldPos:Point = new Point(level.x, level.y);
			var widthMargin:Point = new Point(0, 0);     // margin to account for with/height of player char, assuming center-registered
			
			// modify new point based on input key
			switch(direction)
			{
				case "left":
					newPos.x -= MOVEMENT_SPEED;
					newWorldPos.x += MOVEMENT_SPEED;
					widthMargin.x -= $playerGraphic.width / 2;
					playWorldPlayerAnim("left");
					break;
				case "right":
					newPos.x += MOVEMENT_SPEED;
					newWorldPos.x -= MOVEMENT_SPEED;
					widthMargin.x += $playerGraphic.width / 2;
					playWorldPlayerAnim("right");
					break;
				case "up":
					newPos.y -= MOVEMENT_SPEED;
					newWorldPos.y += MOVEMENT_SPEED;
					widthMargin.y -= $playerGraphic.height / 2;
					playWorldPlayerAnim("up");
					break;
				case "down":
					newPos.y += MOVEMENT_SPEED;
					newWorldPos.y -= MOVEMENT_SPEED;
					widthMargin.y += $playerGraphic.height / 2;
					playWorldPlayerAnim("down");
					break;
				case "none":
					playWorldPlayerAnim("none");
					break;
			} // end of switch 
			
			var isBlocked:Boolean = false;
			var stuff:Array = $playerGraphic.parent.getObjectsUnderPoint($playerGraphic.parent.localToGlobal(new Point(newPos.x + widthMargin.x, newPos.y + widthMargin.y)));
			
			// iterates through everything collected to see if a wall is present
			for (var i:int = 0; i < stuff.length; i++)
			{
				//trace ("Terrain: " + stuff[i].parent + ", " + stuff[i].parent.name + ", Qualified Class Name: " + getQualifiedClassName(stuff[i].parent));
				if (stuff[i].parent is Wall || stuff[i].parent.name == "wall")
					isBlocked = true;
				if (getQualifiedClassName(stuff[i].parent) == "EncounterVolumeEntity" && worldController != null)
				{
					if (direction == "up" || direction == "down" || direction == "left" || direction == "right")
						queryEncounterVolume(worldController.getEntityByName(stuff[i].parent.name));
				} // end of if statement
			} // end of for loop
			
			if (isBlocked) return;
			
			//$playerGraphic.x = newPos.x;
			//$playerGraphic.y = newPos.y;
			
			level.x = newWorldPos.x;
			level.y = newWorldPos.y;
		} // end of function movePlayer
		
		private function playWorldPlayerAnim(dir:String):void
		{
			if (playerGraphic == null) return;
			
			var anim:String;
			
			switch(dir)
			{
				case "left":
					anim = "movement_left";
					break;
				case "right":
					anim = "movement_right";
					break;
				case "up":
					anim = "movement_up";
					break;
				case "down":
					anim = "movement_down";
					break;
				case "none":
					switch(currentAnim)
					{
						case "movement_left":
							anim = "idle_left";
							break;
						case "movement_right":
							anim = "idle_right";
							break;
						case "movement_up":
							anim = "idle_up";
							break;
						case "movement_down":
							anim = "idle_down";
							break;
						default:
							return;
							break;
					} // end of embedded switch
					break;
			} // end of switch
			
			// if animation is already playing, don't interrupt!
			if (currentAnim == anim || anim == null) return;
			
			for (var i:int = 0; i < animWrapper.currentLabels.length; i++)
			{
				if (currentLabels[i] == anim)
				{
					animWrapper.gotoAndPlay(anim);
					break;
				} // end of if statement
			} // end of for loop

			currentAnim = anim;
			
			animWrapper.gotoAndPlay(anim);
		} // end of function playWorldPlayerAnim
		
		private function queryEncounterVolume(volume:MovieClip):void
		{
			//trace ("queried volume! " + volume);
			
			if (volume == null) return;
			//volume.setData( { } );
			volume.onVolumeQuery();
		} // end of function queryEncounterVolume

		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get playerGraphic():MovieClip
		{
			return $playerGraphic;
		} // end of function get playerGraphic
		
		public function set playerGraphic(asset:MovieClip):void
		{
			$playerGraphic = asset;
		} // end of function set playerGraphic
		
		private function get level():MovieClip
		{
			return worldRef.getChildByName("level") as MovieClip;
		} // end of function get level
		
		public function get isMovable():Boolean
		{
			return $isMovable;
		} // end of function get isMovable
		
		public function set isMovable(state:Boolean):void
		{
			$isMovable = state;
		} // end of function set isMovable
		
		private function get animWrapper():MovieClip
		{
			return ($playerGraphic.getChildAt(0) as MovieClip).animWrapper;
		} // end of function get animWrapper
		
	} // end of class PlayerController
	
} // end of package src.Controllers