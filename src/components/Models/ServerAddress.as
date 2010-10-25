package components.Models
{
	public class ServerAddress
	{
		private static var serverAddress:String = "http://localhost:3000/";
		
		public static function getServerAddress():String{
			return serverAddress;
		}
	}
}