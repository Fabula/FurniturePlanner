package command
{
	import business.UserDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.ShowAllUsersMessage;
	
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;
	
	import vo.UserVO;
	
	public class ShowAllUsersCommand implements IResponder
	{
		public function execute(message:ShowAllUsersMessage):void{
			var delegate:UserDelegate = new UserDelegate(this);
			delegate.getAllUsers();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			
			var usersVO:Array = resultEvent.result as Array;
			var	mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			mainAppModel.users = new Array();
			
			for each (var userVO:UserVO in usersVO){
				mainAppModel.users.push(User.fromVO(userVO));
			}
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}