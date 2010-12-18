package messages
{
	public class RemoveProjectMessage
	{
		public var projectID:int;
		
		public function RemoveProjectMessage(projectID:int)
		{
			this.projectID = projectID;
		}
	}
}