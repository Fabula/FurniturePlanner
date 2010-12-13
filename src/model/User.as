package model
{
	import vo.UserVO;
	import vo.OrderVO;

	[Bindable]
	public class User
	{
		public var id:int
		public var name:String;
		public var lastName:String;
		public var telephoneNumber:String;
		public var email:String;
		public var password:String;
		public var systemRole:String;
		public var created_at:Date;
		public var updated_at:Date;
		public var orders:Array;
		
		public function User(name:String, lastName:String, 
							 telephoneNumber:String, email:String, 
							 password:String = "", systemRole:String = "user",
							 createdAt:Date = null, updatedAt:Date = null, id:int = 0)
		{
			this.name = name;
			this.lastName = lastName;
			this.telephoneNumber = telephoneNumber;
			this.email = email;
			this.password = password;
			this.systemRole = systemRole;
			this.id = id;
			this.created_at = createdAt;
			this.updated_at = updatedAt;
		}
		
		public function toVO():UserVO{
			var userVO:UserVO = new UserVO();
			userVO.name = this.name;
			userVO.last_name = this.lastName;
			userVO.telephone_number = this.telephoneNumber;
			userVO.email = this.email;
			userVO.password = this.password;
			userVO.system_role = this.systemRole;
			userVO.password_confirmation = this.password;
			userVO.id = this.id;
			return userVO;
		}
		
		public static function fromVO(userVO:UserVO):User{
			var user:User = new User(userVO.name, 
									 userVO.last_name, 
									 userVO.telephone_number,
									 userVO.email,
									 userVO.password,
									 userVO.system_role,
									 userVO.created_at,
									 userVO.updated_at,
									 userVO.id);
			user.orders = new Array();
			
			for each( var orderVO:OrderVO in userVO.orders){
				user.orders.push(Order.fromVO(orderVO));
			}
			
			return user;
		}
	}
}