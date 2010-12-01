package views.adminPage
{
	import model.User;

	public class CreateUserPM
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function createUser(name:String, lastName:String, telephoneNumber:String, email:String, password:String, role:String):void{
			dispatcher(new User(name, lastName, telephoneNumber, email, password, role));
		}
	}
}