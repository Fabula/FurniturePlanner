package messages
{
	public class DeleteUserMessage
	{
		public var userID:Number;
		
		public function DeleteUserMessage(userID:Number)
		{
			this.userID = userID;
		}
	}
}