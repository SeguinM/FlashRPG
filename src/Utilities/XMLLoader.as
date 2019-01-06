package src.Utilities
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE: 
	 * ---Loads external XML files and returns them.
	 */
	public class  XMLLoader extends MovieClip
	{
		
		// VARIABLES
		private static var loadedXMLs:Array = [];
		private static var loadedXML:XML;
		private static var loader:URLLoader;
		private static var $dispatcher:EventDispatcher = new EventDispatcher();
		private static var loadQueue:Array = [];
		
		// CONTSTS
		private static const EVENT_LOADING_COMPLETE:String = "onAllSWFsComplete";
		private static const EVENT_LOADING_FAIL:String = "onLoadFailEvent";
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function XMLLoader()
		{
			// Not instantiated, no point in doing stuff here
		} // end of function XMLHandler
		
		public static function loadXMLs(paths:Array):void
		{
			// size check
			if (paths.length <= 0) return;
			
			loadQueue = paths;
			
			startLoading(loadQueue[0]);

		} // end of function getXML
		
		public static function getLoadedXML(name:String):XML
		{
			var ret: XML;
			
			for (var i:int = 0; i < loadedXMLs.length; i++)
			{
				//trace ("LOADED XML: " + loadedXMLs[i]);
				
				if ((loadedXMLs[i] as XML).filename == name)
				{
					ret = new XML(loadedXMLs[i]);
				} // end of if statement
			} // end of for loop
			
			return ret;
			
			//var xml:XML = new XML();
			//xml = XML(loader.data);
			//trace (xml);
			//return xml;
		} // end of function getLoadedXML
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static function startLoading(path:String):void
		{
			// creates a new Loader
			loader = new URLLoader();
			
			// path
			var url:URLRequest = new URLRequest(path);
			
			// event listener
			if (!loader.hasEventListener(Event.COMPLETE))
				loader.addEventListener(Event.COMPLETE, onFileLoaded);
				
			if (!loader.hasEventListener(IOErrorEvent.IO_ERROR))
				loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
				
			loader.load(url);
		} // end of static function startLoading
		
		private static function onFileLoaded(event:Event):void
		{
			trace ("XMLLoader::onFileLoaded");
			var xml:XML;
			<strong>xml = new XML (loader.data);</strong>
			//loadedXMLs.push(xml as XML);
			loadedXMLs.push(new XML(loader.data));
			
			loadQueue.splice(0, 1);
			
			if (loadQueue.length > 0)
				startLoading(loadQueue[0]);
				
			else
				onAllXMLsComplete();
			
			//$dispatcher.dispatchEvent(new Event(EVENT_LOADING_COMPLETE));
		} // end of function onFileLoaded
		
		private static function onAllXMLsComplete():void
		{
			trace ("SpriteSwapper::onAllXMLsComplete " + $dispatcher);
			$dispatcher.dispatchEvent(new Event(EVENT_LOADING_COMPLETE));
		} // end of function onAllXMLsComplete
		
		private static function onLoadFail(event:IOErrorEvent):void
		{
			$dispatcher.dispatchEvent(new Event(EVENT_LOADING_FAIL));
			throw new Error("Load Failed at XMLLoader::getXML");
		} // end of function onLoadFail
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get dispatcher():EventDispatcher
		{
			return $dispatcher;
		} // end of function get dispatcher
		
	} // end of class XMLHandler
	
} // end of package src.Utilities