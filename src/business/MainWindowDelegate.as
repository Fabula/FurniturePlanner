package business
{
	import MainPageDestination;
	
	import com.adobe.cairngorm.navigation.NavigationEvent;
	
	import control.Pages;
	
	import model.PlannerModelLocator;

	[Bindable]
	public class MainWindowDelegate
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function navigateToMainWindow(userType:String):void{
			switch(userType){
				case "user":
					dispatcher(NavigationEvent.createNavigateToEvent(MainPageDestination.userPage));
					break;
				case "admin":
					dispatcher(NavigationEvent.createNavigateToEvent(MainPageDestination.adminPage));
					break;
				case "designer":
					dispatcher(NavigationEvent.createNavigateToEvent(MainPageDestination.designerPage));
					break;
				case "manager":
					dispatcher(NavigationEvent.createNavigateToEvent(MainPageDestination.managerPage));
					break;
			}
		}
	}
}