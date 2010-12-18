package views.presentationmodel
{
	import business.room.Room3D;
	
	import flash.utils.ByteArray;
	
	import messages.UpdateProjectMessage;
	
	import model.PlannerModelLocator;
	import model.Project;
	import model.ProjectData;
	import model.RoomSize;
	
	import mx.controls.Alert;
	import mx.utils.Base64Encoder;

	[Bindable]
	public class ToolAreaPM
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		[Embed(source="icons/page_white.png")] 
		public var newProjectIcon:Class; 
		
		[Embed(source="icons/disk.png")] 
		public var saveProjectIcon:Class; 
		
		[Embed(source="icons/printer.png")] 
		public var printProjectIcon:Class; 
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function saveProject():void{
			
			var roomSize:RoomSize = new RoomSize(mainAppModel.room.roomWidth, mainAppModel.room.roomLength, mainAppModel.room.roomHeight);
			// получаем ссылку на текущий проект пользователя
			var customerProject:Project = mainAppModel.currentProject;
			customerProject.projectDataRoomSize = serializeAndEncodeObject(roomSize);
			customerProject.projectDataProductPositions = serializeAndEncodeObject(mainAppModel.room.productsPositions);
			
			if (customerProject.isSaved){
				dispatcher(new UpdateProjectMessage(customerProject));
			}
			else{
				// проект новый, сохраняем его
				dispatcher(customerProject);	
			}
						
		}		
		
		private function serializeAndEncodeObject(object:Object):String{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(byteArray);
			
			var data:String = encoder.toString();
			
			return data;
		}
		
	}
}