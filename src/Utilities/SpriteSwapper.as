package src.Utilities
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import src.Main;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  SpriteSwapper extends MovieClip
	{
		
		// VARIABLES
		private static var loadedSWFs:Array = [];
		private static var loader:Loader;
		private static var $dispatcher:EventDispatcher = new EventDispatcher();
		private static var appDomain:ApplicationDomain = new ApplicationDomain();
		private static var context:LoaderContext = new LoaderContext();
		context.applicationDomain = ApplicationDomain.currentDomain;// appDomain;
		
		private static var loadQueue:Array = [];
		
		// CONTSTS
		public static const EVENT_LOADING_COMPLETE:String = "onAllSWFsComplete";
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function SpriteSwapper()
		{
			$dispatcher = new EventDispatcher();
		} // end of constructor function
		
		public static function loadSWFs(array:Array):void
		{
			trace ("SpriteSwapper::loadSWFs");
			loadQueue = array;
			
			startLoading(array[0]);
		} // end of function loadSWFs
		
		public static function getSprite($asset:String):MovieClip
		{
				
			// seeks out specified image
			var clip:MovieClip;
			
			try
			{
				var refClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition($asset) as Class;
				clip = new refClass as MovieClip;
				//$parent.addChild(clip);
			} // end of try statement
			
			catch (error:Error)
			{
				trace ("Specified asset not found.");
				var placeholder:Shape = new Shape();
				placeholder.graphics.beginFill(0xCC0010);
				placeholder.graphics.drawRect(0, 0, 100, 100);
				placeholder.graphics.endFill();
				clip.addChild(placeholder);
				//$parent.addChild(clip);
			} // end of catch statement
			return clip;
		} // end of funcstion swapSprite
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function startLoading(fileName:String):void
		{
			var url:URLRequest;

			loader = new Loader();
			if (!loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileLoaded);
			url = new URLRequest(fileName);
			loader.load(url, context);
		} // end of function startLoading
		
		private static function onFileLoaded(event:Event):void
		{
			trace (loader.content);
			loadedSWFs.push(event.target.content);
			
			/*try
			{
			if (event.currentTarget.content != null)
				loadedSWFs.push((event.currentTarget as Loader).content);
			} // end of try statement
			
			catch (error:Error)
			{
				trace (error);
			} // end of error statent*/
			
			trace ("SpriteSwapper::onFileLoaded");
			
			loadQueue.splice(0, 1);
			
			if (loadQueue.length > 0)
				startLoading(loadQueue[0]);
				
			else
				onAllSWFsComplete();
			
		} // end of function onFileLoaded
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                  GET / SET FUNCTIONS                                          //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get dispatcher():EventDispatcher
		{
			return $dispatcher;
		} // end of function dispatcher
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                  EVENT FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function onAllSWFsComplete():void
		{
			trace ("SpriteSwapper::onAllSWFsComplete " + $dispatcher);
			$dispatcher.dispatchEvent(new Event(EVENT_LOADING_COMPLETE));
		} // end of function onAllSWFsComplete
		
	} // end of class SpriteSwapper
	
} // end of package src.Utilities