package vo
{
	[RemoteClass(alias='vo.OrderItemVO')]
	[Bindable]
	public class OrderItemVO
	{
		[Transient]
		public var id:int;
		[Transient]
		public var order_id:int;
		public var furniture_product_id:int;
		public var quantity:int;
		
		[Transient]
		public var product:FurnitureProductVO;
	}
}