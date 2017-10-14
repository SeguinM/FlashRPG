package src.Controllers
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  DynamicButton extends MovieClip
	{
		
		public var onClickFunction:Function;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function DynamicButton()
		{
			super();
			init();
		} // end of function DynamicButton
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick)
		} // end of function init
		
		private function onMouseOver(event:MouseEvent):void
		{
			trace ("DynamicButton::onMouseOver");
			setState("over");
		} // end of function onMouseOver
		
		private function onMouseOut(event:MouseEvent):void
		{
			trace ("DynamicButton::onMouseOut");
			setState("active");
		} // end of function onMouseOut
		
		private function onMouseClick(event:MouseEvent):void
		{
			trace ("DynamicButton::onMouseDown");
			setState("down");
			if (onClickFunction != null)
				onClickFunction();
			setState("active");
		} // end of function onMouseClick
		
		private function setState(value:String):void
		{
			for (var i:int = 0; i < currentLabels.length; i++)
			{
				if (currentLabels[i].name == value)
					gotoAndPlay(value);
			}
		} // end of function setState
		
	} // end of class DynamicButton
	
} // end of class src.Controllers