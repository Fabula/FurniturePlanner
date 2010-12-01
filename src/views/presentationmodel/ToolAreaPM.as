package views.presentationmodel
{
	import business.Room3D;
	import mx.controls.Alert;

	[Bindable]
	public class ToolAreaPM
	{
		[Embed(source="icons/page_white.png")] 
		public var newProjectIcon:Class; 
		
		[Embed(source="icons/disk.png")] 
		public var saveProjectIcon:Class; 
		
		[Embed(source="icons/printer.png")] 
		public var printProjectIcon:Class; 
		
		public function loadFurnitureProduct():void{
			// отправить событие, которое откроет pop-up окно
		}		
	}
}