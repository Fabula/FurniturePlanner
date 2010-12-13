package command
{
	import business.OrderDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.CloseCustomerBasketPopUpMessage;
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
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(message:NewOrderMessage):void{
			var delegate:OrderDelegate = new OrderDelegate(this);
			delegate.createOrder(message.order);
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var orderVO:OrderVO = OrderVO(resultEvent.result);
			
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			mainAppModel.orders.push(Order.fromVO(orderVO)); 
			
			Alert.show(ErrorMessageCenter.successOrderCreated + "\n" + "Номер заказа - " + orderVO.id, ErrorMessageCenter.successMessage);
			
			dispatcher(new CloseCustomerBasketPopUpMessage());
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}