package views.userPage
{
	import business.RoomDelegate;
	
	import messages.NewProject;
	
	import model.Project;
	
	import mx.controls.Alert;
	
	public class CreateProjectPanelPM
	{	
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function createProject(projectName:String, roomWidth:int, roomHeight:int, roomLength:int):void{
			dispatcher(new NewProject(projectName, roomWidth, roomHeight, roomLength));
		}
	}
}