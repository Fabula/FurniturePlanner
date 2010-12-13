package command
{
	import business.OrderDelegate;
	
	import flash.events.Event;
	
	import messages.ChangeOrderStatusMessage;
	import messages.GetAllOrdersMessage;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;
	import errorMessages.ErrorMessageCenter;

	public class ChangeOrderStatusCommand implements IResponder
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(message:ChangeOrderStatusMessage):void{
			var delegate:OrderDelegate = new OrderDelegate(this);
			delegate.changeOrdersStatus(message);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			
			if (resultEvent.result == "order_status_changed"){
				dispatcher(new GetAllOrdersMessage());
			}
			else{
				Alert.show(ErrorMessageCenter.changeOrderStatusErrorMessage, ErrorMessageCenter.errorMessageTitle);
			}
			
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}