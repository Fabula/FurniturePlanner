package command
{
	import business.MainWindowDelegate;
	import business.UserDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import flash.events.Event;
	
	import messages.GetMainWindow;
	
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.UserVO;

	public class CreateUserCommand implements IResponder
	{
		[Bindable]
		[Inject]
		public var windowDelegate:MainWindowDelegate;
		
		private var _model:PlannerModelLocator = PlannerModelLocator.getInstance();
			
		public function execute(user:User):void{
			var delegate:UserDelegate = new UserDelegate(this);
			delegate.createUser(user);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			if (resultEvent.result == "error"){
				Alert.show(ErrorMessageCenter.errorAccountCreating, ErrorMessageCenter.errorMessageTitle);
			}
			else{
				_model.currentUser = User.fromVO(UserVO(resultEvent.result));
				Alert.show(ErrorMessageCenter.successAccountCreating, ErrorMessageCenter.successMessage);
				windowDelegate.navigateToMainWindow(_model.currentUser.systemRole);
			}
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}