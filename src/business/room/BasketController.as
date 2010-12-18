package business.room
{
	import alternativa.engine3d.objects.Mesh;
	
	import model.BasketItem;
	import model.FurnitureProduct;
	import model.PlannerModelLocator;

	public class BasketController
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		private var basketItem:BasketItem;
		
		public function placeFurnitureProductToBasket(product:FurnitureProduct, modelMesh:Mesh):void{
			basketItem = BasketItem.toBasketItem(product);
			basketItem.mesh = modelMesh;
			
			var matched:Boolean = false;
			
			for each (var item:BasketItem in mainAppModel.customerBasket){
				if (item.furnitureProductID == basketItem.furnitureProductID){
					item.quantity++;
					matched = true;
				}
			}
			if (!matched){
				mainAppModel.customerBasket.push(basketItem);	
			}
		}
	}
}