package command
{
	import business.SessionDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.DestroySessionMessage;
	
	import model.PlannerModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;

	public class DestroySessionCommand implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function execute(message:DestroySessionMessage):void{
			var delegate:SessionDelegate = new SessionDelegate(this);
			delegate.destroySession();
			
			if (mainAppModel.currentUser.systemRole == "user"){
				mainAppModel.room.removeListener();
				mainAppModel.room = null;
			}
		}
		
		public function result(event:Object):void{

		} 
		
		public function fault(event:Object):void{
			//Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}