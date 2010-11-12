package views.presentationmodel
{
	import com.adobe.cairngorm.navigation.NavigationEvent;
	import com.adobe.cairngorm.navigation.state.ISelectedIndex;
	
	import control.Pages;
	
	import messages.GetSession;
	
	[Bindable]
	public class LoginPanelPM
	{
		public var email:String;
		public var password:String;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function navigateToRegWindow():void{
			dispatcher(NavigationEvent.createNavigateToEvent(Pages.REGISTRATION_STATE));
		}
		
		public function authorize():void{
			dispatcher(new GetSession(email,password));
		}
	}
}