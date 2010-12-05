package command
{
	import business.OrderDelegate;
	
	import messages.GetCustomerOrdersMessage;
	
	import model.PlannerModelLocator;
	import model.Order;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.OrderVO;

	public class LoadCustomerOrdersCommand implements IResponder
	{
		public function execute(message:GetCustomerOrdersMessage):void{
			var delegate:OrderDelegate = new OrderDelegate(this);
			delegate.loadOrders();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			
			var orders:Array = resultEvent.result as Array;
			
			mainAppModel.orders = new Array();
			
			for each (var orderVO:OrderVO in orders){
				mainAppModel.orders.push(Order.fromVO(orderVO));
			}
			
		}
		
		public function fault(event:Object):void{
			
		}
	}
}