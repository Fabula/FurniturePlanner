package messages
{
	import model.Order;

	public class NewOrderMessage
	{		
		public var order:Order;
		
		public function NewOrderMessage(ord:Order)
		{
			order = ord;
		}
	}
}