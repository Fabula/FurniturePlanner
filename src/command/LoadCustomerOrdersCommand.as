package command
{
	import business.OrderDelegate;
	
	import messages.GetCustomerOrdersMessage;
	
	import model.FurnitureProduct;
	import model.Order;
	import model.OrderItem;
	import model.PlannerModelLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.OrderVO;

	public class LoadCustomerOrdersCommand implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function execute(message:GetCustomerOrdersMessage):void{
			var delegate:OrderDelegate = new OrderDelegate(this);
			delegate.loadOrders();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);			
			var orders:Array = resultEvent.result as Array;
			
			mainAppModel.orders = new Array();
			
			for each (var orderVO:OrderVO in orders){
				mainAppModel.orders.push(Order.fromVO(orderVO));
			}
			
			joinFurnitureProducts();
		}
		
		public function fault(event:Object):void{
			
		}
		
		private function joinFurnitureProducts():void{
			// hardcode, dont touch, sloooooooow
			for each (var order:Order in mainAppModel.orders){
				for each (var orderItem:OrderItem in order.orderItems){
					for each (var product:FurnitureProduct in mainAppModel.furnitureProducts){
						if (product.furnitureProductID == orderItem.productID){
							orderItem.furnitureProduct = product;
						}
					}
				}
			}
		}
	}
}