package command
{
	import business.ProjectDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.UpdateProjectMessage;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class UpdateCustomerProjectCommand implements IResponder
	{
		public function execute(message:UpdateProjectMessage):void{
			var delegate:ProjectDelegate = new ProjectDelegate(this);
			delegate.updateProject(message.project);
		}
		
		public function result(event:Object):void{
			var eventResult:ResultEvent = ResultEvent(event);
			
			if (eventResult.result == "project_successfuly_changed"){
				Alert.show(ErrorMessageCenter.successProjectCreated, ErrorMessageCenter.successMessage);
			}
			else{
				Alert.show(ErrorMessageCenter.projectSaveError, ErrorMessageCenter.errorMessageTitle);
			}
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}