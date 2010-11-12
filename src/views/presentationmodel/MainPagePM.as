package views.presentationmodel
{
	import com.adobe.cairngorm.navigation.NavigationEvent;
	
	import control.Pages;
	
	import model.Project;
	
	public class MainPagePM
	{
		[Embed(source="icons/report.png")]
		[Bindable]
		public var furnitureListIcon:Class;
		
		[Embed(source="icons/help.png")]
		[Bindable]
		public var helpButtonIcon:Class;
		
		[Embed(source="icons/cart.png")]
		[Bindable]
		public var buyButtonIcon:Class;
		
		[Embed(source="icons/status_online.png")]
		[Bindable]
		public var accountIcon:Class;
		
		[Embed(source="icons/door_out.png")]
		[Bindable]
		public var logoutIcon:Class;
				
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function logout():void{
			dispatcher(NavigationEvent.createNavigateToEvent(Pages.LOGIN_STATE));
		}
	}
}