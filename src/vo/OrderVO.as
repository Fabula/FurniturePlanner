package vo
{
	[RemoteClass(alias='vo.OrderVO')]
	[Bindable]
	public class OrderVO
	{
		[Transient]
		public var id:int;
		[Transient]
		public var orderItems:Array;
		public var order_status:String;
		public var user_id:int;
		[Transient]
		public var created_at:Date;
	}
}