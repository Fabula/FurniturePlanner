package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import messages.ChangeOrderStatusMessage;
	
	import model.Order;
	
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.OrderVO;

	public class OrderDelegate
	{
		private var responder:IResponder;
		private var _orderRO:RemoteObject;
		
		public function OrderDelegate(responder:IResponder)
		{
			this.responder = responder;
			_orderRO = ServiceLocator.getInstance().getRemoteObject("orderRO");
		}
		
		public function createOrder(order:Order):void{
			var orderVO:OrderVO = order.toVO();
			var call:Object = _orderRO.create.send(orderVO, orderVO.orderItems);
			
			call.addResponder(responder);
		}
		
		public function loadCustomerOrders():void{
			var call:Object = _orderRO.show.send();
			call.addResponder(responder);
		}
		
		public function loadCustomersOrders():void{
			var call:Object = _orderRO.index.send();
			call.addResponder(responder);
		}
		
		public function changeOrdersStatus(message:ChangeOrderStatusMessage):void{
			var call:Object = _orderRO.update.send(message.orderID, message.orderStatus);
			call.addResponder(responder);
		}
	}
}