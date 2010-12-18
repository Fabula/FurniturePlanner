package vo
{
	[RemoteClass(alias='vo.ProjectVO')]
	[Bindable]
	public class ProjectVO
	{
		public var user_id:int;
		public var name:String;
		public var designerHelp:Boolean;
		public var project_data_roomsize:String;
		public var project_data_product_positions:String;
		
		[Transient]
		public var created_at:Date;
		[Transient]
		public var updated_at:Date;
		
		public var id:int;
	}
}