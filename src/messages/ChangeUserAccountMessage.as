package messages
{
	import model.User;

	public class ChangeUserAccountMessage
	{
		public var user:User;
		
		public function ChangeUserAccountMessage(user:User)
		{
			this.user = user;
		}
	}
}