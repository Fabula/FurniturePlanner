package views.userPage
{
	import flash.utils.ByteArray;
	
	import messages.GetCustomerProjects;
	import messages.ImportProjectMessage;
	import messages.ProjectsLoaded;
	import messages.RemoveProjectMessage;
	import messages.UpdateProjectsListMessage;
	
	import model.PlannerModelLocator;
	import model.Project;
	import model.ProjectData;
	import model.RoomSize;
	
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.Base64Decoder;
	
	public class CustomerProjectsPM
	{
		[Bindable]
		public var customerProjects:Array;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[MessageDispatcher]
		public var sendMessage:Function;
		
		public function loadCustomerProjects():void{
			dispatcher(new GetCustomerProjects());
		}
		
		[MessageHandler]
		public function handleProjectLoaded(message:ProjectsLoaded):void{
			customerProjects = message.projects;
			
		}
		
		public function removeProject(project:Project):void{
			dispatcher(new RemoveProjectMessage(project.projectID));
		}
		
		[MessageHandler]
		public function updateProjectsList(message:UpdateProjectsListMessage):void{
			dispatcher(new GetCustomerProjects());
		}
		
		public function convertDate(item:Object, column:DataGridColumn):String{
			return item.created_at.date + "/" + item.created_at.month + "/" + item.created_at.fullYear + " " + item.created_at.hours + ":" + item.created_at.minutes;
		}
		
		public function importProject(project:Project):void{
			var roomSizeData:ByteArray  = decodeObject(project.projectDataRoomSize);
			var roomSize:Object = roomSizeData.readObject();
			var productPositionsData:ByteArray = decodeObject(project.projectDataProductPositions);
			var productPositions:Array = productPositionsData.readObject();
			
			// проверяем сохранялся ли проект пользователя, если да, то просто обновляем запись в бд
			project.isSaved = true;
			
			// делаем его текущим проектом пользователя
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			mainAppModel.currentProject = project;
			
			sendMessage(new ImportProjectMessage(roomSize, productPositions));
		}
		
		private function decodeObject(decodedObject:String):ByteArray{
			var decoder:Base64Decoder = new Base64Decoder();
			var data:ByteArray;
			
			decoder.decode(decodedObject);
			data = decoder.toByteArray();
			
			return data;
		}
	}
}