package command
{
	import business.OrderDelegate;
	
	import messages.NewOrderMessage;
	
	import model.Order;
	import model.PlannerModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.OrderItemVO;
	import vo.OrderVO;

	public class CreateOrderCommand implements IResponder
	{
		public function execute(message:NewOrderMessage):void{
			var delegate:OrderDelegate = new OrderDelegate(this);
			delegate.createOrder(message.order);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var orderVO:OrderVO = OrderVO(resultEvent.result);
			
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			mainAppModel.orders.push(Order.fromVO(orderVO)); 
		}
		
		public function fault(event:Object):void{
			
		}
	}
}