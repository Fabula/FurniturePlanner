package command
{
	import business.ProjectDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.GetCustomersProjects;
	
	import model.Order;
	import model.PlannerModelLocator;
	import model.Project;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.OrderVO;
	import vo.ProjectVO;

	public class LoadCustomersProjects implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function execute(message:GetCustomersProjects):void{
			var delegate:ProjectDelegate = new ProjectDelegate(this);
			delegate.getCustomersProjects();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);			
			var projects:Array = resultEvent.result as Array;
			
			mainAppModel.designerProjects = new Array();
			
			for each (var projectVO:ProjectVO in projects){
				mainAppModel.designerProjects.push(Project.fromProjectVO(projectVO));
			}
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}