package src.Controllers.WorldMenu
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  QuestsTabController extends TabBase
	{
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function QuestsTabController($clip:MovieClip)
		{
			super($clip);
			init();
		} // end of constructor function
		
		override public function refresh():void
		{
			super.refresh();
		} // end of function refresh
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			clip.tab.txt.text = "QUESTS";
		} // end of function init
		
	} // end of class TabBase
	
} // end of package TabBase