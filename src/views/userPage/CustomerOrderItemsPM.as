package views.userPage
{
	import messages.NewOrderMessage;
	
	import model.BasketItem;
	import model.Order;
	import model.OrderItem;
	import model.PlannerModelLocator;
	
	import mx.controls.Alert;

	public class CustomerOrderItemsPM
	{
		[MessageDispatcher]
		public var sendMessage:Function;
		
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		[Bindable]
		public var totalPrice:int = 0;
		
		public function handleCheckBoxSelect():void{
			calculateTotalPrice();
		}
		
		private function calculateTotalPrice():void{
			totalPrice = 0;
			for each (var item:BasketItem in mainAppModel.customerBasket){
				if (item.buy){
					totalPrice += item.price * item.quantity;
				}
			}			
		}
		
		public function createOrder():void{

			var order:Order = new Order(mainAppModel.currentUser.id);
			
			for each (var item:BasketItem in mainAppModel.customerBasket){
				if (item.buy){
					order.orderItems.push(new OrderItem(item.furnitureProductID, item.quantity));
				}
			}	
			sendMessage(new NewOrderMessage(order));			
		}
	}
}