package command
{
	import business.UserDelegate;
	
	import messages.ChangeUserAccountMessage;
	import messages.CloseChangeUserAccountPopUpMessage;
	import messages.ShowAllUsersMessage;
	
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class UpdateUserCommand implements IResponder
	{
		[MessageDispatcher]
		public var dispatcherShowAllUsersMessage:Function;
		
		[MessageDispatcher]
		public var closeChangeUserAccountPopUpDispatcher:Function;
		
		public function execute(message:ChangeUserAccountMessage):void{
			var delegate:UserDelegate = new UserDelegate(this);
			delegate.updateUser(message.user);
		}
		
		public function result(event:Object):void{
			closeChangeUserAccountPopUpDispatcher(new CloseChangeUserAccountPopUpMessage());
			dispatcherShowAllUsersMessage(new ShowAllUsersMessage());
		}
		
		public function fault(event:Object):void{
			
		}
	}
}