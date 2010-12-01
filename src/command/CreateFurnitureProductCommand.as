package command
{
	import business.FurnitureProductDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.AddFurnitureProductToView;
	import messages.GetFurnitureProducts;
	
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.FurnitureProductVO;
	
	public class CreateFurnitureProductCommand implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(product:FurnitureProduct):void{
			var delegate:FurnitureProductDelegate = new FurnitureProductDelegate(this);
			delegate.createModel(product);
		}
		
		public function result(event:Object):void{
			//обработка результата от сервера
			var resultEvent:ResultEvent = ResultEvent(event);
			
			if (resultEvent.result == "loadingError"){
				Alert.show(ErrorMessageCenter.loadFurnitureProductErrorMessage, ErrorMessageCenter.errorMessageTitle);
			} 
			else{
				Alert.show(ErrorMessageCenter.loadFurnitureProductSuccessMessage, ErrorMessageCenter.successMessage);
				var newProduct:FurnitureProduct = FurnitureProduct.fromVO(FurnitureProductVO(resultEvent.result));
				//mainAppModel.furnitureProducts.push(FurnitureProduct.fromVO(FurnitureProductVO(resultEvent.result)));
				// обновим каталог
				//dispatcher(new GetFurnitureProducts());
				dispatcher(new AddFurnitureProductToView(newProduct));
			}
			
			mainAppModel.openProductLoadFormPopUp = false;
		}
		
		public function fault(event:Object):void{
		}
	}
}