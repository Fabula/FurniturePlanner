package model
{
	import business.room.Room3D;
	
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.net.FileReference;
	
	import model.User;
	
	import vo.UserVO;
	
	[Bindable]
	public class PlannerModelLocator implements IModelLocator
	{
		public var currentUser:User;
		public var currentProject:Project;
		public var openNewProjectPopUp:Boolean = false;
		public var openProductLoadFormPopUp:Boolean = false;
		public var openFurnitureProductDescription:Boolean = false;
		
		public var furnitureProducts:Array = new Array();
		public var customerBasket:Array = new Array();
		public var users:Array;
		public var orders:Array;
		
		public var currentProductFile:FileReference;
		public var base64ProductFileString:String;
		
		public var room:Room3D;
		
		public var manufacturersCountries:Array = [
			{label: "Финляндия", data: "finland"},
			{label: "Италия", data: "italy"},
			{label: "Россия", data: "russia"}
		];
		
		public var furnitureStyles:Array = [
			{label: "Современный", data: "modern"},
			{label: "Классический", data: "classic"}
		];
		
		public var furnitureCategories:Array = [
			{label: "Столы и стулья", data: "chairs_and_tables"},
			{label: "Мягкая мебель", data: "sofa"},
			{label: "Шкафы", data: "cupboards"}
		];
		
		public var userCategories:Array = [
			{label: "клиент", data: "user"},
			{label: "дизайнер", data: "designer"},
			{label: "менеджер", data: "manager"}
		];
		
		public var allUserCategories:Array = [
			{label: "все", data: "all"},
			{label: "клиент", data: "user"},
			{label: "дизайнер", data: "designer"},
			{label: "менеджер", data: "manager"},
			{label: "администратор", data: "admin"}
		];
		
		private static var plannerModelLocator:PlannerModelLocator;
		
		public static function getInstance():PlannerModelLocator{
			if (plannerModelLocator == null){
				plannerModelLocator = new PlannerModelLocator();
			}
			return plannerModelLocator;
		}
		
		public function PlannerModelLocator()
		{
			if (plannerModelLocator != null){
				throw new Error("Only one PlannerModelLocator instance can be instanciated");
			}
		}
	}
}