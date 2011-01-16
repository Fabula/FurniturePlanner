package messages
{
	public class UpdateProjectStatusMessage
	{
		public var projectID:int;
		public var help:Boolean;
		
		public function UpdateProjectStatusMessage(projectID:int, help:Boolean = true)
		{
			this.projectID = projectID;
			this.help = help;
		}
	}
}