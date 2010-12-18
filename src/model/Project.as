package model
{
	import vo.ProjectVO;

	[Bindable]
	public class Project
	{
		public var projectID:int;
		public var userID:int;
		public var projectName:String;
		public var projectDesignerHelp:Boolean;
		public var projectDataRoomSize:String;
		public var projectDataProductPositions:String;
		
		public var created_at:Date;
		public var updated_at:Date;
		
		public var isSaved:Boolean;
		
		public function Project(projectName:String, userID:int = 0, 
								projectDesignerHelp:Boolean = false, projectDataRoomSize:String = "", projectDataProductPositions:String = "",
								created_at:Date = null, updated_at:Date = null, projectID:int = 0)
		{
			this.projectID = projectID;
			this.userID = userID;
			this.projectName = projectName;
			this.projectDesignerHelp = projectDesignerHelp;
			this.projectDataRoomSize = projectDataRoomSize;
			this.projectDataProductPositions = projectDataProductPositions;
			this.created_at = created_at;
			this.updated_at = updated_at;
		}
		
		public function toProjectVO():ProjectVO{
			var projectVO:ProjectVO = new ProjectVO();
			projectVO.name = this.projectName;
			projectVO.user_id = this.userID;
			projectVO.designerHelp = this.projectDesignerHelp;
			projectVO.project_data_roomsize = this.projectDataRoomSize;
			projectVO.project_data_product_positions = this.projectDataProductPositions;
			projectVO.created_at = this.created_at;
			projectVO.updated_at = this.updated_at;
			projectVO.id = this.projectID;
			return projectVO;
		}
		
		public static function fromProjectVO(projectVO:ProjectVO):Project{
			var project:Project = new Project(projectVO.name, projectVO.user_id, 
											  projectVO.designerHelp, projectVO.project_data_roomsize, projectVO.project_data_product_positions,
											  projectVO.created_at, projectVO.updated_at, projectVO.id);
			return project;							  
		}
	}
}