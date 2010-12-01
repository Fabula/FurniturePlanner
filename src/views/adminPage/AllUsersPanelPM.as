package views.adminPage
{
	import messages.CloseChangeUserAccountPopUpMessage;
	import messages.CloseCreateUserPopUpMessage;
	import messages.DeleteUserMessage;
	import messages.RequiredUsersMessage;
	
	import model.PlannerModelLocator;
	import model.User;

	[Bindable]
	public class AllUsersPanelPM
	{
		[Embed(source="icons/vcard_add.png")] 
		public var addUserAccountIcon:Class; 
		
		[Embed(source="icons/vcard_delete.png")] 
		public var deleteUserAccountIcon:Class; 
		
		[Embed(source="icons/vcard_edit.png")] 
		public var editUserAccountIcon:Class; 
		
		public var showCreateUserPopUp:Boolean = false;
		public var showChangeUserPopUp:Boolean = false;
		
		[MessageHandler]
		public function closeCreateUserPopUp(message:CloseCreateUserPopUpMessage):void{
			showCreateUserPopUp = false;
		}
		
		[MessageHandler]
		public function closeChangeAccountPopUp(message:CloseChangeUserAccountPopUpMessage):void{
			showChangeUserPopUp = false;
		}
		
		[MessageDispatcher]
		public var sendDeleteUserMessage:Function;
		
		public function deleteUser(userID:Number):void{
			sendDeleteUserMessage(new DeleteUserMessage(userID));
		}
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function searchUser(surName:String = "", role:String = ""):void{
			var requiredUsers:Array = new Array();
			
			if (role == "all"){
				for each (var user:User in mainAppModel.users){
					if ((user.lastName.toLocaleLowerCase().search(surName) > -1)){
						requiredUsers.push(user);
					}
				}
			}
			else{
				for each (var user:User in mainAppModel.users){
					if ((user.lastName.toLocaleLowerCase().search(surName) > -1) && (user.systemRole == role)){
						requiredUsers.push(user);
					}
				}
			}
				
			dispatcher(new RequiredUsersMessage(requiredUsers));		
		}
	}
}