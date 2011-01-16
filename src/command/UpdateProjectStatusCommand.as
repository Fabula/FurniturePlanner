package command
{
	import business.ProjectDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.UpdateProjectStatusMessage;
	import messages.GetCustomerProjects;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import org.spicefactory.lib.util.Delegate;

	public class UpdateProjectStatusCommand implements IResponder
	{
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(message:UpdateProjectStatusMessage):void{
			var delegate:ProjectDelegate = new ProjectDelegate(this);
			delegate.changeProjectStatus(message.projectID, message.help);
		}
		
		public function result(event:Object):void{
			var eventResult:ResultEvent = ResultEvent(event);
			
			if (eventResult.result == "error"){
				Alert.show(ErrorMessageCenter.errorMessageTitle, ErrorMessageCenter.projectStatusChangedError);
			}
			else{
				Alert.show(ErrorMessageCenter.projectStatusChangedSuccess, ErrorMessageCenter.successMessage);
				dispatcher(new GetCustomerProjects());
			}
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}