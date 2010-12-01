package command
{
	import business.ProjectDelegate;
	import business.RoomDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.GetFurnitureProducts;
	import messages.NewProject;
	
	import model.PlannerModelLocator;
	import model.Project;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import vo.ProjectVO;

	public class CreateProjectCommand implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		private var message:NewProject;
		
		[Bindable]
		[Inject]
		public var roomDelegate:RoomDelegate;

		public function execute(_message:NewProject):void{
			var delegate:ProjectDelegate = new ProjectDelegate(this);
			message = _message;
			var userID:int = mainAppModel.currentUser.id;
			
			var project:Project = new Project(message.projectName, userID);
			delegate.createProject(project);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			if (resultEvent.result == "error"){
				Alert.show(ErrorMessageCenter.projectCreateError, ErrorMessageCenter.errorMessageTitle);
			}
			else{
				var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
				mainAppModel.currentProject = Project.fromProjectVO((ProjectVO(resultEvent.result)));
				mainAppModel.openNewProjectPopUp = false;
				
				roomDelegate.createRoom(message.roomWidth, message.roomHeight, message.roomLength);
			}
		}
		
		public function fault(event:Object):void{
			
		}
	}
}