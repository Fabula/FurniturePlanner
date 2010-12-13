package messages
{
	public class ChangeOrderStatusMessage
	{
		public var orderID:Number;
		public var orderStatus:String;
		
		public function ChangeOrderStatusMessage(orderID:Number, orderStatus:String)
		{
			this.orderID = orderID;
			this.orderStatus = orderStatus;
		}
	}
}