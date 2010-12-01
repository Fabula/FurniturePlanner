package command
{
	import business.MainWindowDelegate;
	import business.UserDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import flash.events.Event;
	
	import messages.CloseCreateUserPopUpMessage;
	import messages.GetFurnitureProducts;
	import messages.GetMainWindow;
	import messages.ShowAllUsersMessage;
	
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
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[MessageDispatcher]
		public var getProductsDispatcher:Function;
		
		[MessageDispatcher]
		public var getAllUsers:Function;
		
		[MessageDispatcher]
		public var closeCreateUserPopUp:Function;
			
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
				if (mainAppModel.currentUser.systemRole == "admin"){
					// обновить список пользователей
					closeCreateUserPopUp(new CloseCreateUserPopUpMessage());
					getAllUsers(new ShowAllUsersMessage());
				}
				else{
					// устанавливаем текущего пользователя
					mainAppModel.currentUser = User.fromVO(UserVO(resultEvent.result));
					Alert.show(ErrorMessageCenter.successAccountCreating, ErrorMessageCenter.successMessage);
					// открываем соответствующее окно
					dispatcher(new GetMainWindow(mainAppModel.currentUser.systemRole));
					// загружаем каталог
					getProductsDispatcher(new GetFurnitureProducts());
				}
			}
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}