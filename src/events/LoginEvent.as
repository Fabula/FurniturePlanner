package events
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const LOGIN:String = "login";
		public var user:XML;
		
		public function LoginEvent(user:XML)
		{
			super(LOGIN);
			this.user = user;
		}
	}
}