package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
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
	}
}