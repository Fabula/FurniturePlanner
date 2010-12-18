package command
{
	import business.ProjectDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.RemoveProjectMessage;
	import messages.UpdateProjectsListMessage;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class DeleteCustomerProjectCommand implements IResponder
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(message:RemoveProjectMessage):void{
			var delegate:ProjectDelegate = new ProjectDelegate(this);
			delegate.removeProject(message.projectID);
		}
		
		public function result(event:Object):void{
			var eventResult:ResultEvent = ResultEvent(event);
			
			if (eventResult.result == "project_successfuly_deleted"){
				Alert.show(ErrorMessageCenter.successProjectDeleted, ErrorMessageCenter.successMessage);
			}
			
			dispatcher(new UpdateProjectsListMessage());
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}