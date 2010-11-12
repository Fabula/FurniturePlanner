package command
{
	import business.MainWindowDelegate;
	
	import com.adobe.cairngorm.navigation.NavigationEvent;
	
	import messages.GetMainWindow;
	
	public class NavigateToMainWindow
	{
		[Bindable]
		[Inject]
		public var delegate:MainWindowDelegate;
		
		public function execute(message:GetMainWindow):void{
			delegate.navigateToMainWindow(message._userType);
		}
	}
}