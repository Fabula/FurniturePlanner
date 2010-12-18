package business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import model.Project;
	
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	import vo.ProjectVO;

	public class ProjectDelegate
	{
		private var _responder:IResponder;
		private var _projectRO:RemoteObject;
		
		public function ProjectDelegate(responder:IResponder)
		{
			_responder = responder;
			_projectRO = ServiceLocator.getInstance().getRemoteObject("projectRO");
		}
		
		public function saveProject(project:Project):void{
			var call:Object = _projectRO.create.send(project.toProjectVO());
			call.addResponder(_responder);
		}
		
		public function getProjects():void{
			var call:Object = _projectRO.index.send();
			call.addResponder(_responder);
		}
		
		public function removeProject(projectID:int):void{
			var call:Object = _projectRO.destroy.send({projectID: projectID});
			call.addResponder(_responder);
		}
		
		public function updateProject(project:Project):void{
			
			var projectVO:ProjectVO = project.toProjectVO();
			var call:Object = _projectRO.update.send(projectVO);
			call.addResponder(_responder);
		}
		
	}
}