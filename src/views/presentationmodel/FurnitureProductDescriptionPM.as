package views.presentationmodel
{
	import messages.AddFurnitureProductToRoom;
	import model.FurnitureProduct;
	import mx.controls.Alert;

	[Bindable]
	public class FurnitureProductDescriptionPM
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function addFurnitureProductToRoom(product:FurnitureProduct):void{
			dispatcher(new AddFurnitureProductToRoom(product));
		}
	}
}