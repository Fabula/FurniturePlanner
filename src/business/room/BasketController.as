package business.room
{
	import model.BasketItem;
	import model.FurnitureProduct;
	import model.PlannerModelLocator;

	public class BasketController
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		private var basketItem:BasketItem;
		
		public function placeFurnitureProductToBasket(product:FurnitureProduct):void{
			basketItem = BasketItem.toBasketItem(product);
			
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