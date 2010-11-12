package events
{
	import flash.events.Event;
	
	public class CreateUserClickedEvent extends Event
	{
		public static const CREATEUSERCLICKED:String = "createUserClicked";
		public var newUserData:XML;
		
		public function CreateUserClickedEvent(_newUserData:XML)
		{
			super(CREATEUSERCLICKED);
			this.newUserData = _newUserData;
		}
	}
}