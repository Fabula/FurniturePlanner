package components.Models
{
	import flash.events.*;

	public class Users extends EventDispatcher
	{

		private var usersList:XMLList;
		
		[Bindable]
		public var currentUser:Object;
		
		[Bindable]
		public var specificUsers:XMLList;
		
		[Bindable]
		public var requiredUsers:XMLList;
		
		public static const userCategories:Array = [
			{label: "все", data: "all"},
			{label: "посетитель", data: "customer"},
			{label: "дизайнер", data: "designer"},
			{label: "менеджер", data: "manager"},
			{label: "администратор", data: "admin"}
		];
		
		public static const categories:Array = [
			{label: "посетитель", data: "customer"},
			{label: "дизайнер", data: "designer"},
			{label: "менеджер", data: "manager"},
			{label: "администратор", data: "admin"}
		];
		
		// получить список пользователей
		public function getListOfUsers():XMLList{
			return usersList;
		}
		
		// изменить список пользователей
		public function setUsers(_users:XMLList):void{
			usersList = _users;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setCurrentUser(_currentUser:Object):void{
			currentUser = _currentUser;
		}
	}
}