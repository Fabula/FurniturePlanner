package events
{
	import flash.events.Event;
	
	public class ProjectEvent extends Event
	{
		
		public static const PROJECT_CREATE:String = "projectCreate";
		public var project:XML;
		
		
		public function ProjectEvent(type:String, project:XML)
		{
			super(type);
			this.project = project;
		}
	}
}