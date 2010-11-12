package messages
{
	public class GetSession
	{
		public var email:String;
		public var password:String;
		
		public function GetSession(email:String, password:String)
		{
			this.email = email;
			this.password = password;
		}
	}
}