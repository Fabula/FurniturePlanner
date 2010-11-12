package messages
{
	public class NewProject
	{
		public var roomWidth:int;
		public var roomHeight:int;
		public var roomLength:int;
		public var projectName:String;
		
		public function NewProject(projectName:String, roomWidth:int, roomHeight:int, roomLength:int)
		{
			this.projectName = projectName;
			this.roomHeight = roomHeight;
			this.roomWidth = roomWidth;
			this.roomLength = roomLength;
		}
	}
}