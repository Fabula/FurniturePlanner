package components.Controllers
{
	import components.Models.ServerAddress;
	import components.Models.Users;
	
	import flash.events.*;
	
	import mx.controls.Alert;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class UsersController
	{
		private var model:Users;
		
		private var srvGetUsersList:HTTPService;
		private var srvCreateNewUser:HTTPService;
		private var srvDeleteUser:HTTPService;
		private var srvChangeUserData:HTTPService;
		
		public function UsersController(_model:Users){
			this.model = _model;
		}
		
		
		/* Create new user
		---------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------*/
		public function createNewUser(_login:String, _email:String, _name:String, _surName:String, _telephoneNumber:String, _userType:String, _password:String, _passwordConfirm:String):void{
			// it's looking so awful
			var newUserData:XML = new XML(
				"<user>" +
				"<login>"+ _login + "</login>" +
				"<email>"+ _email + "</email>" +
				"<name>" + _name + "</name>" +
				"<last_name>" + _surName + "</last_name>" +
				"<telephone_number>" + _telephoneNumber + "</telephone_number>" +
				"<system_role>" + _userType + "</system_role>" +
				"<password>" + _password + "</password>" +
				"<password_confirmation>"+ _passwordConfirm + "</password_confirmation>" +
				"</user>");
			
			
			srvCreateNewUser = new HTTPService();
			srvCreateNewUser.url = ServerAddress.getServerAddress() + "users.xml";
			srvCreateNewUser.method = "POST";
			srvCreateNewUser.contentType = HTTPService.CONTENT_TYPE_XML;
			srvCreateNewUser.request = newUserData;			
			srvCreateNewUser.addEventListener(ResultEvent.RESULT, createUserHTTPResultHandler);
			srvCreateNewUser.addEventListener(FaultEvent.FAULT, createUserHTTPFaultHandler);
			srvCreateNewUser.send();
		}
		
		private function createUserHTTPResultHandler(event:ResultEvent):void{
			Alert.show("Учетная запись пользователя создана", "Уведомление");
			getUsersList();
		}
		
		private function createUserHTTPFaultHandler(event:Fault):void{
			Alert.show(event.faultDetail);
		}
		
		/* Get users list
		-----------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------*/
		public function getUsersList():void{
			srvGetUsersList = new HTTPService();
			srvGetUsersList.showBusyCursor;
			srvGetUsersList.url = ServerAddress.getServerAddress() + "users.xml";
			srvGetUsersList.method = "GET";
			srvGetUsersList.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			srvGetUsersList.addEventListener("result", getUsersListHTTPResultHandler);
			srvGetUsersList.addEventListener("fault", getUsersListFaultHandler);
			srvGetUsersList.send();
		}
		
		private function getUsersListHTTPResultHandler(event:ResultEvent):void{
			model.setUsers(XMLList(event.result));
		}
		
		private function getUsersListFaultHandler(event:Fault):void{
			Alert.show(event.faultString);
		}
		
		/* Delete user data
		-----------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------*/
		public function deleteUser(userID:String):void{
			srvDeleteUser = new HTTPService;
			srvDeleteUser.url = ServerAddress.getServerAddress() + "users/" + userID + ".xml";
			srvDeleteUser.method = "POST";
			srvDeleteUser.addEventListener(ResultEvent.RESULT, deleteUserHTTPResultHandler);
			srvDeleteUser.addEventListener(FaultEvent.FAULT, deleteUserFaultHandler);
			srvDeleteUser.send({_method:"DELETE"});	
		}
		
		private function deleteUserHTTPResultHandler(event:ResultEvent):void{
			Alert.show("Учетная запись успешно удалена","Уведомление");
			clearCurrentObjectFields();
			getUsersList();	
		}
		
		private function clearCurrentObjectFields():void{
			model.currentUser.name = "";
			model.currentUser.last_name = "";
			model.currentUser.telephone_number = "";
			model.currentUser.email = "";
			model.currentUser.login = "";
		}
		
		private function deleteUserFaultHandler(event:Fault):void{
			Alert.show(event.faultString);
		}
		
		
		/* Change user data
		-----------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------*/
		public function changeUserData(userID:String, _login:String, _email:String, _name:String, 
									   _surName:String, _telephoneNumber:String):void{
			
/*			var newUserData:XML = new XML(
				"<user>" +
					"<login>" + _login + "</login>" +
					"<email>" + _email + "</email>" +
					"<name>" + _name + "</name>" +
					"<last_name>" + _surName + "</last_name>" +
					"<telephone_number>" + _telephoneNumber + "</telephone_number>" +
				"</user>");*/
			var newUserData:XML = new XML("<user><name>" + _name + "</name></user>");
			
			srvChangeUserData = new HTTPService;
			srvChangeUserData.url = ServerAddress.getServerAddress() + "users/" + userID + ".xml";
			srvChangeUserData.method = "POST";
			srvChangeUserData.addEventListener(ResultEvent.RESULT, changeUserDataResultHandler);
			srvChangeUserData.addEventListener(FaultEvent.FAULT, changeUserDataFaultHandler);
			srvChangeUserData.send();
		}
		
		private function changeUserDataResultHandler(event:ResultEvent):void{
			Alert.show("Данные учетной записи изменены", "Уведомление");
			getUsersList();
		}
		
		private function changeUserDataFaultHandler(event:FaultEvent):void{
			Alert.show(event.fault.faultString);			
		}
		
		/* Handle datagrid click
		-----------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------*/
			
		public function handleDataGridClickEvent(selectedItem:Object):void{
			model.currentUser = selectedItem;
		}
		
		public function handleUserCategoriesChange(chosenItem:String):void{
			var usersList:XMLList = model.getListOfUsers();
			model.specificUsers = usersList.user.(system_role == chosenItem);
		}
		
		public function searchHandler(searchString:String):void{
			var requiredUsers:XMLList = model.getListOfUsers().user.(last_name == searchString);
			model.requiredUsers = requiredUsers;
		}
	}
}