package org.papervision3d.events
{
	import flash.events.Event;
	
	/**
	* The AnimationEvent class represents events that are dispatched by the animation engine.
	*/
	public class AnimationEvent extends Event
	{
		public static const COMPLETE 		:String = "animationComplete";
		public static const ERROR    		:String = "animationError";
		public static const NEXT_FRAME		:String = "animationNextFrame";
		public static const START			:String = "animationStart";
		public static const STOP			:String = "animationStop";
		public static const PAUSE			:String = "animationPause";
		public static const RESUME			:String = "animationResume";
		
		public var time :Number;
		public var clip :String;	
		public var data :Object;

		public function AnimationEvent( type:String, time:Number, clip:String="", data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super( type, bubbles, cancelable );
			this.time = time;
			this.clip = clip;
			this.data = data;
		}
		
		override public function clone():Event
		{
			return new AnimationEvent(type, time, clip, data, bubbles, cancelable);
		}
	}
}