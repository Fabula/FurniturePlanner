package views.designerPage
{
	import flash.events.Event;
	import flash.net.FileReference;
	
	import messages.FileLoadedMessage;
	import messages.GetFileMessage;
	
	import model.FurnitureModel;
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	
	public class CreateFurnitureProductPM
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		[Bindable]
		public var file:FileReference;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[MessageDispatcher]
		public var sendFurnitureProduct:Function;
		
		public function get3DModel():void{
			dispatcher(new GetFileMessage());
		}
		
		[MessageHandler]
		public function receiveFile(message:FileLoadedMessage):void{
			file = message.file;
		}
		
		public function uploadModel(manufacturerName:String, manufacturerCountry:String, furnitureStyle:String,
									furnitureCategory:String, price:Number, description:String, height:Number, width:Number, length:Number):void{
			
			var model:FurnitureModel = new FurnitureModel(file.data, height, width, length);
			
			var fproduct:FurnitureProduct = new FurnitureProduct(manufacturerName, manufacturerCountry, furnitureStyle, furnitureCategory, price, model, description);
			sendFurnitureProduct(fproduct);
		}
	}
}