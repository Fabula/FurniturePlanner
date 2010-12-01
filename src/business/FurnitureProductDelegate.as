package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import model.FurnitureProduct;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.FurnitureProductVO;

	public class FurnitureProductDelegate
	{
		// ссылка на команду, которая создает данный delegate
		private var _responder:IResponder;
		private var _furnitureModelRO:RemoteObject;
		
		public function FurnitureProductDelegate(responder:IResponder)
		{
			_responder = responder;
			_furnitureModelRO = ServiceLocator.getInstance().getRemoteObject("furnitureModelRO");
		}
		
		public function createModel(furnitureProduct:FurnitureProduct):void{
			var furnitureProductVO:FurnitureProductVO = furnitureProduct.toVO();
			var call:Object = _furnitureModelRO.create.send(furnitureProductVO);
			
			call.addResponder(_responder);
		}
		
		public function loadFurnitureProducts():void{
			var call:Object = _furnitureModelRO.index.send();
			call.addResponder(_responder);
		}
	}
}