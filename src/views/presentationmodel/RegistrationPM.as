package views.presentationmodel
{
	import MainPageDestination;
	
	import com.adobe.cairngorm.navigation.NavigationEvent;
	
	import control.Pages;
	
	import errorMessages.ErrorMessageCenter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import messages.GetMainWindow;
	
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.controls.Alert;
	
	[Bindable]
	public class RegistrationPM
	{
		public var email:String;
		public var firstName:String;
		public var lastName:String;
		public var telephoneNumber:String;
		public var password:String;
		public var passwordConfirmation:String;
		public var passwordsMatch:Boolean;
		public var user:User;

		[MessageDispatcher]
		public var dispatcher:Function;
		
		[MessageDispatcher]
		public var sendCreateUser:Function;
		
		public function onChangeConfirmationInput(ev:Event):void{
			if (password == passwordConfirmation){
				passwordsMatch = true;
				ev.target.errorString = "";
			}
			else{
				passwordsMatch = false;
				ev.target.errorString = ErrorMessageCenter.passwordsNotMatched;
			}
		}
		
		public function navigateToLoginWindow(event:MouseEvent):void{
			dispatcher(NavigationEvent.createNavigateToEvent(Pages.LOGIN_STATE));
		}
		
		public function createUserAccount(event:MouseEvent):void{
			var user:User = new User(firstName, lastName, telephoneNumber, email, password);
			sendCreateUser(user);
		}
	}
}