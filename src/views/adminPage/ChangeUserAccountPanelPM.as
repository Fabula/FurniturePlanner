package views.adminPage
{
	import messages.ChangeUserAccountMessage;
	import messages.DeleteUserMessage;
	
	import model.User;
	
	public class ChangeUserAccountPanelPM
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function changeUserAccount(id:int, name:String, surName:String, telephoneNumber:String, email:String, password:String, role:String):void{
			var user:User = new User(name, surName, telephoneNumber, email, password, role, null, null, id);
			dispatcher(new ChangeUserAccountMessage(user));
		}
	}
}