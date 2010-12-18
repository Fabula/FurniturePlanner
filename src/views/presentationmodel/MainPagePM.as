package views.presentationmodel
{
	import com.adobe.cairngorm.navigation.NavigationEvent;
	
	import control.Pages;
	
	import messages.CloseCustomerBasketPopUpMessage;
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
		
		[Embed(source="icons/images.png")]
		[Bindable]
		public var customerProjectsIcon:Class;
		
		[Bindable]
		public var openCustomerBasket:Boolean = false;
		
		[Bindable]
		public var openCustomerOrders:Boolean = false;
		
		[Bindable]
		public var openCustomerProjects:Boolean = false;
				
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[MessageDispatcher]
		public var sendMessage:Function;
		
		public function logout():void{
			dispatcher(NavigationEvent.createNavigateToEvent(Pages.LOGIN_STATE));
			sendMessage(new DestroySessionMessage());
		}
		
		[MessageHandler]
		public function closeCustomerBasketPopUp(message:CloseCustomerBasketPopUpMessage):void{
			openCustomerBasket = false;
		}
	}
}