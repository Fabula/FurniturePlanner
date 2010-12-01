package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	public class SessionDelegate
	{
		private var _responder:IResponder;
		private var _sessionRO:RemoteObject;
		
		public function SessionDelegate(responder:IResponder)
		{
			_responder = responder;
			_sessionRO = ServiceLocator.getInstance().getRemoteObject("sessionRO");
		}
		
		public function createSession(_email:String, _password:String):void{
			var call:Object = _sessionRO.create.send({email: _email, password: _password});
			call.addResponder(_responder);
		}
		
		public function destroySession():void{
			var call:Object = _sessionRO.destroy();
			call.addResponder(_responder);
		}
	}
}