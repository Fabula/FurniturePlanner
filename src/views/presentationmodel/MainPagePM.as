package views.presentationmodel
{
	import com.adobe.cairngorm.navigation.NavigationEvent;
	
	import control.Pages;
	
	import messages.DestroySessionMessage;
	
	import model.Project;
	
	public class MainPagePM
	{
		[Embed(source="icons/report.png")]
		[Bindable]
		public var customerOrdersIcon:Class;
		
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
		
		[Bindable]
		public var openCustomerBasket:Boolean = false;
		
		[Bindable]
		public var openCustomerOrders:Boolean = false;
				
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[MessageDispatcher]
		public var sendMessage:Function;
		
		public function logout():void{
			dispatcher(NavigationEvent.createNavigateToEvent(Pages.LOGIN_STATE));
			sendMessage(new DestroySessionMessage());
		}
	}
}