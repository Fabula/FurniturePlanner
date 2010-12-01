package command
{
	import business.UserDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.DeleteUserMessage;
	import messages.ShowAllUsersMessage;
	
	import model.PlannerModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class DeleteUserCommand implements IResponder
	{
		[MessageDispatcher]
		public var sendShowAllUsersMessage:Function;
		
		public function execute(message:DeleteUserMessage):void{
			var delegate:UserDelegate = new UserDelegate(this);
			delegate.deleteUser(message.userID);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			if (resultEvent.result == "success"){
				Alert.show("Учетная запись успешно удалена", ErrorMessageCenter.successMessage);
				sendShowAllUsersMessage(new ShowAllUsersMessage);
			}
		}
		
		public function fault(event:Object):void{
			
		}
	}
}