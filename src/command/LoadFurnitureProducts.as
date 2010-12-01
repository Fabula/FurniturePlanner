package command
{
	import business.FurnitureProductDelegate;
	
	import messages.CreateProductsPanelMessage;
	import messages.GetFurnitureProducts;
	
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.FurnitureProductVO;

	public class LoadFurnitureProducts implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(message:GetFurnitureProducts):void{
			var delegate:FurnitureProductDelegate = new FurnitureProductDelegate(this);
			delegate.loadFurnitureProducts();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var furnitureProductsVO:Array = resultEvent.result as Array;

			for each (var prVO:FurnitureProductVO in furnitureProductsVO){
				mainAppModel.furnitureProducts.push(FurnitureProduct.fromVO(prVO));
			}
			
			// отправим сообщение виду, чтобы он создал себя
			dispatcher(new CreateProductsPanelMessage());
		}
		
		public function fault(event:Object):void{
			
		}
	}
}