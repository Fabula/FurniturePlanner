package command
{
	import business.MainWindowDelegate;
	import business.SessionDelegate;
	
	import messages.GetSession;
	import errorMessages.ErrorMessageCenter;
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import vo.UserVO;

	public class CreateSessionCommand implements IResponder
	{
		[Bindable]
		[Inject]
		public var windowDelegate:MainWindowDelegate;
		
		public function execute(userData:GetSession):void{
			var delegate:SessionDelegate = new SessionDelegate(this);
			delegate.createSession(userData.email, userData.password);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var _model:PlannerModelLocator = PlannerModelLocator.getInstance();
			_model.currentUser = User.fromVO(UserVO(resultEvent.result));
			windowDelegate.navigateToMainWindow(_model.currentUser.systemRole);
			_model.openNewProjectPopUp = true;
		}
		
		public function fault(event:Object):void{
			var faultEvent:FaultEvent = FaultEvent(event);
			if (faultEvent.fault.faultString == "error"){
				Alert.show(ErrorMessageCenter.loginError, ErrorMessageCenter.errorMessageTitle);
			}
			else{
				Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
			}
		}
	}
}