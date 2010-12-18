package messages
{
	import model.Project;

	public class UpdateProjectMessage
	{
		public var project:Project;
		
		public function UpdateProjectMessage(pr:Project)
		{
			project = pr;
		}
	}
}