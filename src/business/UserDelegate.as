package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import model.User;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;

	public class UserDelegate
	{
		public var _responder:IResponder;
		public var _userRO:RemoteObject;
		
		public function UserDelegate(responder:IResponder){
			_responder = responder;
			_userRO = ServiceLocator.getInstance().getRemoteObject("userRO");
		}
						
		public function createUser(data:User):void{
			var call:Object = _userRO.create.send(data.toVO());
			call.addResponder(_responder);
		}
	}
}