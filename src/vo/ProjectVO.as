package vo
{
	[RemoteClass(alias='vo.ProjectVO')]
	[Bindable]
	public class ProjectVO
	{
		public var user_id:int;
		public var name:String;
		public var designerHelp:Boolean;
		public var project_data:String;
		public var created_at:Date;
		public var updated_at:Date;
	}
}