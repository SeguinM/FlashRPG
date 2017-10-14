package src.Controllers.WorldMenu
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  TabBase extends MovieClip
	{
		
		protected var clip:MovieClip;
		
		public static const EVENT_REFRESH_DATA:String = "refreshDataRequestEvent";
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function TabBase($clip:MovieClip)
		{
			internalInit($clip);
			super();
		} // end of constructor function
		
		public function refresh():void
		{
			// override me
		} // end of function refresh
		
		public function addItem(params:Object):void
		{
			// override me
		} // end of function addItem
		
		public function updateItem(params:Object):void
		{
			// override me
		} // end of function updateItem
		
		public function removeItem(params:Object):void
		{
			// override me
		} // end of functio removeItem
		
		public function removeAll():void
		{
			// override me
		} // end of function removeAll
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function internalInit($clip:MovieClip):void
		{
			clip = $clip;
			$clip.tab.mouseEnabled = false;
			$clip.tab.mouseChildren = false;
		} // end of function internalInit
		
	} // end of class TabBase
	
} // end of package TabBase