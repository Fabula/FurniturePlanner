package views.designerPage
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import messages.GetFileMessage;
	
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	
	import mx.controls.Alert;

	public class CreateFurnitureProductPM
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[MessageDispatcher]
		public var sendFurnitureProduct:Function;
		
		public function get3DModel():void{
			dispatcher(new GetFileMessage());
		}
		
		public function uploadModel(manufacturerName:String, manufacturerCountry:String, furnitureStyle:String,
									furnitureCategory:String, price:Number, description:String):void{
			var fproduct:FurnitureProduct = new FurnitureProduct(manufacturerName, manufacturerCountry, furnitureStyle, furnitureCategory, price, mainAppModel.base64ProductFileString, description);
			sendFurnitureProduct(fproduct);
		}
	}
}