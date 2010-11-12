package model
{
	import vo.ProjectVO;

	[Bindable]
	public class Project
	{
		public var userID:int;
		public var projectName:String;
		public var projectDesignerHelp:Boolean;
		public var projectData:String;
		public var created_at:Date;
		public var updated_at:Date;
		
		public function Project(projectName:String, userID:int = 0, 
								projectDesignerHelp:Boolean = false, projectData:String = "",
								created_at:Date = null, updated_at:Date = null)
		{
			this.userID = userID;
			this.projectName = projectName;
			this.projectDesignerHelp = projectDesignerHelp;
			this.projectData = projectData;
			this.created_at = created_at;
			this.updated_at = updated_at;
		}
		
		public function toProjectVO():ProjectVO{
			var projectVO:ProjectVO = new ProjectVO();
			projectVO.name = this.projectName;
			projectVO.user_id = this.userID;
			projectVO.designerHelp = this.projectDesignerHelp;
			projectVO.project_data = this.projectData;
			projectVO.created_at = this.created_at;
			projectVO.updated_at = this.updated_at;
			return projectVO;
		}
		
		public static function fromProjectVO(projectVO:ProjectVO):Project{
			var project:Project = new Project(projectVO.name, projectVO.user_id, 
											  projectVO.designerHelp, projectVO.project_data,
											  projectVO.created_at, projectVO.updated_at);
			return project;							  
		}
	}
}