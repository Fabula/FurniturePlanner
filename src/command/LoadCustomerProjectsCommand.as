package command
{
	import business.ProjectDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.GetCustomerProjects;
	import messages.ProjectsLoaded;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.ProjectVO;
	import model.Project;

	public class LoadCustomerProjectsCommand implements IResponder
	{
		[MessageDispatcher]
		public var sender:Function;
		
		public function execute(message:GetCustomerProjects):void
		{
			var delegate:ProjectDelegate = new ProjectDelegate(this);
			delegate.getProjects();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);			
			var projectsVO:Array = resultEvent.result as Array;
			// обработать объекты ProjectVO;
			var projects:Array = new Array();
			
			for each(var projectVO:ProjectVO in projectsVO){
				projects.push(Project.fromProjectVO(projectVO));
			}
			
			sender(new ProjectsLoaded(projects));
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}