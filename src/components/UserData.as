package components
{
	public class UserData
	{
		private static var _instance:UserData;
		
		public static function getInstance():UserData{
			if (!_instance){
				_instance = new UserData();
			}
			
			return _instance;
		}
		
		private var _user:XML;
		
		public function setUserData(user:XML):void{
			UserData.getInstance()._user = user;
		}
		
		public function getUserData():XML{
			return UserData.getInstance()._user;
		}

	}
}