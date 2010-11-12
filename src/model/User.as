package model
{
	import vo.UserVO;

	public class User
	{
		[Bindable]
		public var id:int
		
		[Bindable]
		public var name:String;
		
		[Bindable]
		public var lastName:String;
		
		[Bindable]
		public var telephoneNumber:String;
		
		[Bindable]
		public var email:String;
			
		[Bindable]
		public var password:String;
		
		[Bindable]
		public var systemRole:String;
		
		[Bindable]
		public var created_at:Date;
		
		[Bindable]
		public var updated_at:Date;
		
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
			return userVO;
		}
		
		public static function fromVO(userVO:UserVO):User{
			return new User(userVO.name, 
							userVO.last_name, 
							userVO.telephone_number,
							userVO.email,
							userVO.password,
							userVO.system_role,
							userVO.created_at,
							userVO.updated_at,
							userVO.id);
		}
	}
}