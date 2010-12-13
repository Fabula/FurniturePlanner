package command
{
	import business.MainWindowDelegate;
	import business.SessionDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.GetFurnitureProducts;
	import messages.GetMainWindow;
	import messages.GetSession;
	import messages.ShowAllUsersMessage;
	
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import vo.UserVO;

	public class CreateSessionCommand implements IResponder
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(userData:GetSession):void{
			var delegate:SessionDelegate = new SessionDelegate(this);
			delegate.createSession(userData.email, userData.password);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			
			mainAppModel.currentUser = User.fromVO(UserVO(resultEvent.result));
			
			var userRole:String = mainAppModel.currentUser.systemRole;

			// открыть для пользователя окно, которое соответствует его роли
			dispatcher(new GetMainWindow(userRole));
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