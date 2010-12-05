package model
{
	import vo.OrderItemVO;
	import vo.OrderVO;
	
	public class Order
	{
		public var orderID:int;
		public var orderUserID:int;
		public var orderStatus:String;
		public var orderCreatedDate:Date;
		public var orderItems:Array;

		public function Order(userID:int){
			this.orderUserID = userID;
			this.orderItems = new Array();
		}
		
		public function toVO():OrderVO{
			var orderVO:OrderVO = new OrderVO();
			orderVO.orderItems = new Array();
			orderVO.status = this.orderStatus;
			orderVO.user_id = this.orderUserID;
				
			for each (var orderItem:OrderItem in orderItems){
				orderVO.orderItems.push(orderItem.toVO());
			}
			
			return orderVO;
		}
		
		public static function fromVO(orderVO:OrderVO):Order{
			var order:Order = new Order(orderVO.user_id);
			order.orderID = orderVO.id;
			order.orderStatus = orderVO.status;
			order.orderCreatedDate = orderVO.created_at;
			order.orderItems = new Array();
			
			for each (var orderItemVO:OrderItemVO in orderVO.orderItems){
				order.orderItems.push(OrderItem.fromVO(orderItemVO));
			}
			
			return order;
		}
		
	}
}