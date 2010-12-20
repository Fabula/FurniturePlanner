package command
{
	import business.OrderDelegate;
	
	import messages.GetCustomerOrdersMessage;
	
	import model.FurnitureProduct;
	import model.Order;
	import model.OrderItem;
	import model.PlannerModelLocator;
	
	import errorMessages.ErrorMessageCenter;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.controls.Alert;
	
	import vo.OrderVO;

	public class LoadCustomerOrdersCommand implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function execute(message:GetCustomerOrdersMessage):void{
			var delegate:OrderDelegate = new OrderDelegate(this);
			delegate.loadCustomerOrders();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);			
			var orders:Array = resultEvent.result as Array;
			
			mainAppModel.customerOrders = new Array();
			
			for each (var orderVO:OrderVO in orders){
				mainAppModel.customerOrders.push(Order.fromVO(orderVO));
			}
			
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
		
	}
}