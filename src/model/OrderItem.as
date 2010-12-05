package model
{
	import vo.OrderItemVO;

	public class OrderItem
	{
		public var productID:int;
		public var quantity:int;
		
		public var furnitureProduct:FurnitureProduct;
		
		public function OrderItem(productID:int, quantity:int)
		{
			this.productID = productID;
			this.quantity = quantity;
		}
		
		public function toVO():OrderItemVO{
			var orderItemVO:OrderItemVO = new OrderItemVO();
			orderItemVO.furniture_product_id = this.productID;
			orderItemVO.quantity = this.quantity;
			
			return orderItemVO;
		}
		
		public static function fromVO(orderItemVO:OrderItemVO):OrderItem{
			var orderItem:OrderItem = new OrderItem(orderItemVO.furniture_product_id, orderItemVO.quantity);
			
			return orderItem;
		}
	}
}