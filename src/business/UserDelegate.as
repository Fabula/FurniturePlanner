package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import model.User;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;

	public class UserDelegate
	{
		public var responder:IResponder;
		public var userRO:RemoteObject;
		
		public function UserDelegate(responder:IResponder){
			this.responder = responder;
			userRO = ServiceLocator.getInstance().getRemoteObject("userRO");
		}
						
		public function createUser(data:User):void{
			var call:Object = userRO.create.send(data.toVO());
			call.addResponder(responder);
		}
		
		public function getAllUsers():void{
			var call:Object = userRO.index.send();
			call.addResponder(responder);
		}
		
		public function updateUser(user:User):void{
			var call:Object = userRO.update.send(user.toVO());
			call.addResponder(responder);
			
		}
		
		public function deleteUser(userID:Number):void{
			var call:Object = userRO.destroy.send({id: userID});
			call.addResponder(responder);
		}
	}
}