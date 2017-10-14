package src.Controllers.WorldMenu
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.Events.EventWithData;
	import flash.utils.getDefinitionByName;
	import src.Utilities.SpriteSwapper;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  PartyTabController extends TabBase
	{
		
		
		private var elements:Array = [];
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function PartyTabController(clip:MovieClip)
		{
			super(clip);
			init();
		} // end of constructor function
		
		override public function refresh():void
		{
			trace("PartyTabController::refresh");
			super.refresh();
			this.dispatchEvent(new EventWithData(EVENT_REFRESH_DATA, { controller: this}));
		} // end of function refresh
		
		public function populate(params:Object):void
		{
			trace ("PartyTabController::populate");
			
			var characters:Array = params.characters;
			
			if (characters == null) return;
			if (characters.length == 0) return;
			
			removeAll();
			
			for (var i:int = 0; i < characters.length; i++)
			{
				var newElement:MovieClip = SpriteSwapper.getSprite("PartyDataItemUI");
				content.addChild(newElement);
				newElement.x = 0;
				newElement.y = i * newElement.height;
				newElement.setData(characters[i]);
				newElement.mouseEnabled = false;
				newElement.mouseChildren = false;
				elements.push(newElement);
			} // end of for loop
		} // end of function populate
		
		override public function removeAll():void
		{
			while (content.numChildren > 0)
				content.removeChildAt(0);
				
			elements = [];
		} // end of override function removeAll
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			clip.tab.txt.text = "PARTY";
		} // end of function init
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function get content():MovieClip
		{
			return clip.getChildByName("content") as MovieClip;
		} // end of function get content
		
	} // end of class TabBase
	
} // end of package TabBase