package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import model.Project;
	
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;

	public class ProjectDelegate
	{
		private var _responder:IResponder;
		private var _projectRO:RemoteObject;
		
		public function ProjectDelegate(responder:IResponder)
		{
			_responder = responder;
			_projectRO = ServiceLocator.getInstance().getRemoteObject("projectRO");
		}
		
		public function createProject(project:Project):void{
			var call:Object = _projectRO.create.send(project.toProjectVO());
			call.addResponder(_responder);
		}
		
		public function listProjects():void{
			
		}
	}
}