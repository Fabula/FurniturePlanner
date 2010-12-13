package vo
{
	[RemoteClass(alias='vo.UserVO')]
	[Bindable]
	public class UserVO
	{
		public var id:int;
		public var name:String;
		public var last_name:String;
		public var telephone_number:String;
		public var email:String;
		public var system_role:String;
		public var password:String;
		public var password_confirmation:String;
		public var created_at:Date;
		public var updated_at:Date;
		
		[Transient]
		public var orders:Array;
	}
}