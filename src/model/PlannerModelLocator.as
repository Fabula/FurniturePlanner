package model
{
	import com.adobe.cairngorm.model.IModelLocator;
	
	import model.User;
	
	import vo.UserVO;
	
	[Bindable]
	public class PlannerModelLocator implements IModelLocator
	{
		public var currentUser:User;
		public var currentProject:Project;
		public var openNewProjectPopUp:Boolean = false;
		
		public var toolAreaWidth:Number;
		public var toolAreaHeight:Number;
		
		private static var plannerModelLocator:PlannerModelLocator;
		
		public static function getInstance():PlannerModelLocator{
			if (plannerModelLocator == null){
				plannerModelLocator = new PlannerModelLocator();
			}
			return plannerModelLocator;
		}
		
		public function PlannerModelLocator()
		{
			if (plannerModelLocator != null){
				throw new Error("Only one PlannerModelLocator instance can be instanciated");
			}
		}
	}
}