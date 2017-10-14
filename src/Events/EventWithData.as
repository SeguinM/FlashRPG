package src.Events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  EventWithData extends Event
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var internalData:Object;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function EventWithData(type:String, data:Object, bubbles:Boolean = false, cancelable: Boolean = false)
		{
			internalData = data;
			super(type, bubbles, cancelable);
		} // end of public function EventWithData
		
		public function get data():Object
		{
			return internalData;
		} // end of function get data
		
	} // end of class EventWithData
	
} // enDate of package src